//
//  InfoViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import KakaoSDKShare
import RxKakaoSDKShare
import KakaoSDKCommon
import KakaoSDKTemplate

class InfoViewModel {
    var userUid = ""
    var NFTID = ""
    let thumbnail = BehaviorRelay<URL?>(value: nil)
    let username = BehaviorRelay<String?>(value: nil)
    var likeCount = BehaviorRelay<Int>(value: 0)
    var commentCount = BehaviorRelay<Int>(value: 0)
    var reportCount = BehaviorRelay<Int>(value: 0)
    var likedPeople = BehaviorRelay<[String]>(value: [])
    var saveCount = BehaviorRelay<Int>(value: 0)
    
    let deleteImageSubject = PublishSubject<Void>()
    let deleteVideoSubject = PublishSubject<Void>()
    let deleteNFTSubject = PublishSubject<Void>()
    let reduceTravelLevelSubject = PublishSubject<Void>()
    let processCompleted = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init(NFTID: String) {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            self.NFTID = NFTID
            if let photoURL = user.photoURL, let nickname = user.displayName {
                thumbnail.accept(photoURL)
                username.accept(nickname)
            }
            interActionCountSnapshot()
        } else {
            print("현재 로그인한 유저가 없습니다.")
        }
        
        Observable.zip(deleteImageSubject, deleteVideoSubject, deleteNFTSubject, reduceTravelLevelSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func likeAction() {
        db.collection("NFT").document(NFTID).getDocument { (document, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let NFT = document.makeNFT()
                    let likedPeople = NFT.likedPeople
                    if likedPeople.contains(self.userUid) {
                        db.collection("NFT").document(self.NFTID).updateData(["likedPeople": FieldValue.arrayRemove([self.userUid])])
                        db.collection("NFT").document(self.NFTID).updateData(["likes": FieldValue.increment(Int64(-1))])
                    } else {
                        db.collection("NFT").document(self.NFTID).updateData(["likedPeople": FieldValue.arrayUnion([self.userUid])])
                        db.collection("NFT").document(self.NFTID).updateData(["likes": FieldValue.increment(Int64(1))])
                    }
                }
            }
        }
    }
    
    func interActionCountSnapshot() {
        db.collection("NFT").document(NFTID).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let NFT = document.makeNFT()
                    self.likeCount.accept(NFT.likes)
                    self.commentCount.accept(NFT.comments)
                    self.reportCount.accept(NFT.reports)
                    self.saveCount.accept(NFT.saves)
                    self.likedPeople.accept(NFT.likedPeople)
                }
            }
        }
    }
    
    func delete(NFTID: String, category: String) {
        deleteImage(NFTID: NFTID)
        deleteVideo(NFTID: NFTID)
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
    
    func deleteVideo(NFTID: String) {
        let videoRef = ref.child("NFTVideo/\(NFTID)")
        videoRef.delete { error in
            if let error = error as NSError?, let code = StorageErrorCode(rawValue: error.code) {
                switch code {
                case .objectNotFound:
                    self.deleteVideoSubject.onNext(())
                default:
                    print("비디오 삭제 에러: \(error)")
                }
            } else {
                self.deleteVideoSubject.onNext(())
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
    
    func shareNFT(NFT: NFT) {
        let templateID = 101300
        let templateArgs = ["photo": NFT.url, "title": NFT.title, "content": NFT.content, "userImage": thumbnail.value!.absoluteString, "userName": username.value!]
        
        ShareApi.shared.rx.shareCustom(templateId:Int64(templateID), templateArgs: templateArgs)
            .subscribe(onSuccess: { (sharingResult) in
                UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
            }, onFailure: {error in
                print("NFT 공유 에러: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
