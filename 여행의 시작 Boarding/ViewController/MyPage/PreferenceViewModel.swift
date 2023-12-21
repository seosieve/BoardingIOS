//
//  PreferenceViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/18.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import FirebaseAuth
import AuthenticationServices

class PreferenceViewModel: NSObject {
    
    var loginType = ""
    
    let deleteUserSubject = PublishSubject<Void>()
    let deleteUserImageSubject = PublishSubject<Void>()
    let deleteProfileSubject = PublishSubject<Void>()
    let deleteNFTSubject = PublishSubject<Void>()
    let deleteNFTImageSubject = PublishSubject<Void>()
    let deleteNFTVideoSubject = PublishSubject<Void>()
    
    let items = BehaviorRelay<[String]>(value: ["프로필 편집", "차단 유저 목록", "이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"])
    let messageArr = BehaviorRelay<[(String, String, String)]>(value: [("정말 로그아웃 하시겠어요?", "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!", "로그아웃"), ("정말 회원탈퇴 하시겠어요?", "아쉽지만 다음에 기회가 된다면 다시 Boarding을 찾아주세요!", "회원탈퇴")])
    
    var currentNonce: String?
    
    let errorCatch = PublishRelay<Bool>()
    let processCompleted = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        if let currentUser = Auth.auth().currentUser {
            for userInfo in currentUser.providerData {
                switch userInfo.providerID {
                case "apple.com":
                    loginType = "apple"
                default:
                    loginType = "kakao"
                }
            }
        }
        
        Observable.zip(deleteUserSubject, deleteUserImageSubject, deleteProfileSubject, deleteNFTSubject, deleteNFTImageSubject, deleteNFTVideoSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - LogOut
    func logOut() {
        if loginType == "kakao" {
            //카카오 로그아웃
            UserApi.shared.rx.logout()
                .subscribe(onCompleted: { [weak self] in
                    self?.signOutUser()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오 로그아웃 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            //애플 로그아웃
            self.signOutUser()
        }
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            processCompleted.onNext(())
            print("로그아웃 성공")
        } catch let error as NSError {
            errorCatch.accept(true)
            print("로그아웃 에러: \(error.localizedDescription)")
        }
    }
    
    //MARK: - DeleteUser
    func unLink() {
        if loginType == "kakao" {
            //카카오 계정삭제
            UserApi.shared.rx.unlink()
                .subscribe(onCompleted: { [weak self] in
                    guard let currentUser = Auth.auth().currentUser,
                          let email = UserDefaults.standard.string(forKey: "kakaoEmail"),
                          let password = UserDefaults.standard.string(forKey: "kakaoPassword") else { return }
                    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
                    currentUser.reauthenticate(with: credential) { (result, error) in
                        if let error = error {
                            print("유저 재인증 실패: \(error)")
                        } else {
                            print("유저 재인증 성공")
                            self?.deleteUserImage(uid: currentUser.uid)
                            self?.deleteProfile(uid: currentUser.uid)
                            self?.deleteUser()
                            self?.deleteNFT()
                            self?.deleteNFTImage()
                            self?.deleteNFTVideo()
                        }
                    }
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오 연결끊기 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            //애플 계정삭제
            appleUnLink()
        }
    }
    
    func deleteUserImage(uid: String) {
        let imageRef = ref.child("UserImage/\(uid)")
        imageRef.delete { [weak self] error in
            if let error = error {
                print("유저 프로필 이미지 삭제 에러: \(error)")
            } else {
                print("유저 프로필 이미지 삭제 성공")
                self?.deleteUserImageSubject.onNext(())
            }
        }
    }
    
    func deleteProfile(uid: String) {
        db.collection("User").document(uid).delete() { [weak self] error in
            if let error = error {
                print("유저 프로필 삭제 에러: \(error)")
            } else {
                print("유저 프로필 삭제 성공")
                self?.deleteProfileSubject.onNext(())
            }
        }
    }
    
    func deleteUser() {
        guard let currentUser = Auth.auth().currentUser else { return }
        currentUser.delete { [weak self] error in
            if let error = error {
                print("유저 계정 삭제 에러: \(error)")
            } else {
                print("계정 삭제 성공")
                self?.deleteUserSubject.onNext(())
            }
        }
    }
    
    func deleteNFT() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let dispatchGroup = DispatchGroup()
        db.collection("NFT").whereField("authorUid", isEqualTo: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("유저 NFT 쿼리 에러: \(error)")
            } else {
                if querySnapshot!.documents.isEmpty {
                    print("유저 소유 NFT 존재하지 않음")
                    self.deleteNFTSubject.onNext(())
                }
                for document in querySnapshot!.documents {
                    // 유저 소유 NFT 삭제
                    dispatchGroup.enter()
                    db.collection("NFT").document(document.documentID).delete { error in
                        if let error = error {
                            print("유저 NFT 삭제 에러: \(error)")
                        } else {
                            print("유저 NFT 삭제 성공")
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.deleteNFTSubject.onNext(())
                }
            }
        }
    }
    
    func deleteNFTImage() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let dispatchGroup = DispatchGroup()
        db.collection("NFT").whereField("authorUid", isEqualTo: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("유저 NFT 쿼리 에러: \(error)")
            } else {
                if querySnapshot!.documents.isEmpty {
                    print("유저 소유 NFT 존재하지 않음")
                    self.deleteNFTImageSubject.onNext(())
                }
                for document in querySnapshot!.documents {
                    // 유저 소유 NFT 이미지 삭제
                    dispatchGroup.enter()
                    let imageRef = ref.child("NFTImage/\(document.documentID)")
                    imageRef.delete { error in
                        if let error = error {
                            print("유저 NFT 이미지 삭제 에러: \(error)")
                        } else {
                            print("유저 NFT 이미지 삭제 성공")
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.deleteNFTImageSubject.onNext(())
                }
            }
        }
    }
    
    func deleteNFTVideo() {
        guard let currentUser = Auth.auth().currentUser else { return }
        let dispatchGroup = DispatchGroup()
        db.collection("NFT").whereField("authorUid", isEqualTo: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("유저 NFT 쿼리 에러: \(error)")
            } else {
                if querySnapshot!.documents.isEmpty {
                    print("유저 소유 NFT 존재하지 않음")
                    self.deleteNFTVideoSubject.onNext(())
                }
                for document in querySnapshot!.documents {
                    // 유저 소유 NFT 이미지 삭제
                    let NFT = document.makeNFT()
                    if NFT.type == "video" {
                        dispatchGroup.enter()
                        let videoRef = ref.child("NFTVideo/\(document.documentID)")
                        videoRef.delete { error in
                            if let error = error {
                                print("유저 NFT 동영상 삭제 에러: \(error)")
                            } else {
                                print("유저 NFT 동영상 삭제 성공")
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main) {
                    self.deleteNFTVideoSubject.onNext(())
                }
            }
        }
    }
    
    func appleUnLink() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension PreferenceViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let currentUser = Auth.auth().currentUser else { return }
            guard let nonce = currentNonce else { return }
            guard let appleIdToken = appleIDCredential.identityToken else { return }
            guard let tokenString = String(data: appleIdToken, encoding: .utf8) else { return }
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
            
            let token = UserDefaults.standard.string(forKey: "refreshToken")
            if let token = token {
                let url = URL(string: "https://us-central1-boarding-ef2f1.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    guard data != nil else { return }
                }
                task.resume()
            }
            
            currentUser.reauthenticate(with: credential) { authResult, error in
                if let error = error {
                    print("유저 재인증 실패: \(error)")
                } else {
                    print("유저 재인증 성공")
                    currentUser.unlink(fromProvider: "apple.com") { (result, error) in
                        if let error = error {
                            print("애플 연결끊기 실패: \(error.localizedDescription)")
                        } else {
                            print("애플 연결끊기 성공")
                            self.deleteUserImage(uid: currentUser.uid)
                            self.deleteProfile(uid: currentUser.uid)
                            self.deleteUser()
                            self.deleteNFT()
                            self.deleteNFTImage()
                            self.deleteNFTVideo()
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //X버튼 누를때도 실행되기 때문에 에러처리 안했음
        print("애플 로그인 에러: \(error.localizedDescription)")
        self.errorCatch.accept(false)
    }
}
