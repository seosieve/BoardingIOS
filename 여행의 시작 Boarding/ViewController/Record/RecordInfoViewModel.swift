//
//  RecordInfoViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import KakaoSDKShare
import RxKakaoSDKShare
import KakaoSDKCommon
import KakaoSDKTemplate

class RecordInfoViewModel {
    let thumbnail = BehaviorRelay<URL?>(value: nil)
    let username = BehaviorRelay<String?>(value: nil)
    let deleteCompleted = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            if let photoURL = user.photoURL, let nickname = user.displayName {
                thumbnail.accept(photoURL)
                username.accept(nickname)
            }
        } else {
            print("현재 로그인한 유저가 없습니다.")
        }
    }
    
    func NFTDelete(NFTID: String) {
        deleteImage(NFTID: NFTID) {
            db.collection("NFT").document(NFTID).delete() { error in
                if let error = error {
                    print("NFT 삭제 에러: \(error)")
                } else {
                    self.deleteCompleted.onNext(())
                }
            }
        }
    }
    
    func deleteImage(NFTID: String, completion: @escaping () -> Void) {
        let imageRef = ref.child("NFTImage/\(NFTID)")
        imageRef.delete { error in
            if let error = error {
                print("이미지 삭제 에러: \(error)")
            } else {
                completion()
            }
        }
    }
    
    func NFTshare(NFT: NFT) {
        let templateId = 101300

        let templateArgs = ["photo": NFT.url, "title": NFT.title, "content": NFT.content, "userImage": thumbnail.value!.absoluteString, "userName": username.value!]
        
        ShareApi.shared.rx.shareCustom(templateId:Int64(templateId), templateArgs: templateArgs)
            .subscribe(onSuccess: { (sharingResult) in
                print("shareCustom() success.")
                
                UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
            }, onFailure: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
