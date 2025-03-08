//
//  EditProfileViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/17/23.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseStorage

class EditProfileViewModel {
    var userUid = ""
    var thumbnail: URL?
    var username: String?
    let introduce = BehaviorRelay<String?>(value: nil)
    
    let thumbnailSubject = PublishSubject<Void>()
    let nicknameSubject = PublishSubject<Void>()
    let introduceSubject = PublishSubject<Void>()
    let thumbnailCompleted = PublishSubject<Void>()
    let nicknameCompleted = PublishSubject<Void>()
    let introduceCompleted = PublishSubject<Void>()
    let processCompleted = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            guard let photoURL = user.photoURL else { return }
            guard let nickname = user.displayName else { return }
            self.userUid = user.uid
            self.thumbnail = photoURL
            self.username = nickname
            getIntroduce()
        }
        
        thumbnailSubject
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.thumbnailCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        nicknameSubject
            .skip(1)
            .subscribe(onNext: { [weak self] in
                self?.nicknameCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        introduceSubject
            .subscribe(onNext: { [weak self] in
                self?.introduceCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        Observable.zip(thumbnailCompleted, nicknameCompleted, introduceCompleted)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)   
    }
    
    func getIntroduce() {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("유저 소개글 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    self.introduce.accept(user.introduce)
                }
            }
        }
    }
    
    func changeThumbnail(image: UIImage?) {
        //기존 프로필 이미지 삭제
        ref.child("UserImage/\(userUid)").delete { error in
            if let error = error {
                print("유저 프로필 이미지 삭제 에러: \(error)")
            } else {
                print("유저 프로필 이미지 삭제 성공")
            }
        }
        
        //프로필 이미지 저장
        guard let imageData = image?.jpegData(compressionQuality: 0.6) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageRef = ref.child("UserImage/\(userUid)")
        imageRef.putData(imageData, metadata: metaData) { metaData, error in
            imageRef.downloadURL { url, _ in
                guard let url = url else { return }
                //Auth 변경
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges { error in
                    if let error = error {
                        print("Auth 이미지URL 변경 에러: \(error)")
                    } else {
                        print("Auth 이미지URL 변경 성공")
                        self.thumbnailSubject.onNext(())
                    }
                }
                //Firestore 변경
                db.collection("User").document(self.userUid).updateData(["url" : url.absoluteString]) { error in
                    if let error = error {
                        print("Firestore 이미지URL 변경 에러: \(error)")
                    } else {
                        print("Firestore 이미지URL 변경 성공")
                        self.thumbnailSubject.onNext(())
                    }
                }
            }
        }
    }
    
    func changeNickname(_ nickname: String) {
        //Auth 변경
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nickname
        changeRequest?.commitChanges { error in
            if let error = error {
                print("Auth 닉네임 변경 에러: \(error)")
            } else {
                print("Auth 닉네임 변경 성공")
                self.nicknameSubject.onNext(())
            }
        }
        //Firestore 변경
        db.collection("User").document(userUid).updateData(["name" : nickname]) { error in
            if let error = error {
                print("Firestore 닉네임 변경 에러: \(error)")
            } else {
                print("Firestore 닉네임 변경 성공")
                self.nicknameSubject.onNext(())
            }
        }
    }
    
    func changeIntroduce(_ introduce: String) {
        db.collection("User").document(userUid).updateData(["introduce" : introduce]) { error in
            if let error = error {
                print("소개글 변경 에러: \(error)")
            } else {
                print("소개글 변경 성공")
                self.introduceSubject.onNext(())
            }
        }
    }
}
