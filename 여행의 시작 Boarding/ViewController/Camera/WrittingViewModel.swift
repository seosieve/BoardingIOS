//
//  WrittingViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/06.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class WrittingViewModel {
    let NFTID = db.collection("NFT").document().documentID
    
    var userUid = ""
    let location = BehaviorRelay<String>(value: "")
    let country = BehaviorRelay<String>(value: "")
    let city = BehaviorRelay<String>(value: "")
    let latitude = BehaviorRelay<Double>(value: 0.0)
    let longitude = BehaviorRelay<Double>(value: 0.0)
    let time = BehaviorRelay<String>(value: "")
    let weather = BehaviorRelay<String>(value: "")
    let title = BehaviorRelay<String>(value: "")
    let content = BehaviorRelay<String>(value: "")
    let starPoint = BehaviorRelay<Int>(value: 0)
    let category = BehaviorRelay<String>(value: "")
    
    let NFTResult = PublishRelay<NFT>()
    
    let dataValid: Observable<Bool>
    let uploadProgress = BehaviorRelay<Float>(value: 0)
    let writtingResult = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
        }
        
        dataValid = Observable.combineLatest(title, content, starPoint, category)
            .map{ $0.0 != "제목을 입력해주세요." && $0.1 != "내용을 입력해주세요." && $0.2 != 0 && $0.3 != ""}
    }
    
    func writeNFT(image: UIImage?) {
        uploadImage(image: image) { [weak self] url in
            self?.saveNFT(url: url!) {
                self?.addTravelLevel()
            }
        }
    }
    
    func uploadImage(image: UIImage?, handler: @escaping (URL?) -> Void) {
        guard let imageData = image?.jpegData(compressionQuality: 0.6) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = NFTID
        let imageRef = ref.child("NFTImage/\(imageName)")
        let uploadTask = imageRef.putData(imageData, metadata: metaData) { metaData, error in
            imageRef.downloadURL { url, _ in
                handler(url)
            }
        }
        
        //업로드 진행률 모니터링
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            self.uploadProgress.accept(Float(percentComplete))
        }
    }
    
    func saveNFT(url: URL, handler: @escaping () -> Void) {
        let NFT = NFT(NFTID: NFTID,
                      authorUid: userUid,
                      writtenDate: NSDate().timeIntervalSince1970,
                      type: "photo",
                      url: url.absoluteString,
                      location: location.value,
                      country: country.value,
                      city: city.value,
                      latitude: latitude.value,
                      longitude: longitude.value,
                      time: time.value,
                      weather: weather.value,
                      title: title.value,
                      content: content.value,
                      starPoint: starPoint.value,
                      category: category.value,
                      comments: 0, likes: 0, saves: 0, reports: 0,
                      likedPeople: [])
        NFTResult.accept(NFT)
        
        db.collection("NFT").document(NFTID).setData(NFT.dicType) { error in
            if let error = error {
                print("NFT 저장 에러: \(error)")
            } else {
                print("NFT 저장 성공: \(self.NFTID)")
                handler()
            }
        }
    }
    
    func addTravelLevel() {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    var travelLevel = user.travelLevel
                    if let index = CategoryInfo.name.firstIndex(of: self.category.value) {
                        travelLevel[index] += 30
                    }
                    db.collection("User").document(self.userUid).updateData(["travelLevel": travelLevel]) { error in
                        if let error = error {
                            print("travelLevel 증가 에러: \(error)")
                            self.writtingResult.accept(false)
                        } else {
                            print("travelLevel 증가 성공")
                            self.writtingResult.accept(true)
                        }
                    }
                }
            }
            
        }
    }
}
