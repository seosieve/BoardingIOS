//
//  NFTDetailViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class NFTDetailViewModel {
    
    var userUid = ""
    let deleteImageSubject = PublishSubject<Void>()
    let deleteNFTSubject = PublishSubject<Void>()
    let reduceTravelLevelSubject = PublishSubject<Void>()
    let processCompleted = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
        }
        
        Observable.zip(deleteImageSubject, deleteNFTSubject, reduceTravelLevelSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func delete(NFTID: String, category: String) {
        deleteImage(NFTID: NFTID)
        deleteNFT(NFTID: NFTID)
        reduceTravelLevel(category: category)
    }
    
    func deleteImage(NFTID: String) {
        let imageRef = ref.child("NFTImage/\(NFTID)")
        imageRef.delete { error in
            if let error = error {
                print("이미지 삭제 에러: \(error)")
            } else {
                self.deleteImageSubject.onNext(())
            }
        }
    }
    
    func deleteNFT(NFTID: String) {
        db.collection("NFT").document(NFTID).delete() { error in
            if let error = error {
                print("NFT 삭제 에러: \(error)")
            } else {
                self.deleteNFTSubject.onNext(())
            }
        }
    }
    
    func reduceTravelLevel(category: String) {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    var travelLevel = user.travelLevel
                    if let index = CategoryInfo.name.firstIndex(of: category) {
                        travelLevel[index] -= 30
                    }
                    db.collection("User").document(self.userUid).updateData(["travelLevel": travelLevel]) { error in
                        if let error = error {
                            print("travelLevel 감소 에러: \(error)")
                        } else {
                            print("travelLevel 감소 성공")
                            self.reduceTravelLevelSubject.onNext(())
                        }
                    }
                }
            }
            
        }
    }
}
