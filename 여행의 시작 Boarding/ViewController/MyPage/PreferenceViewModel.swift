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
    
    let deleteUserSubject = PublishSubject<Void>()
    let deleteUserImageSubject = PublishSubject<Void>()
    let deleteProfileSubject = PublishSubject<Void>()
    
    let items = BehaviorRelay<[String]>(value: ["이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"])
    let messageArr = BehaviorRelay<[(String, String, String)]>(value: [("정말 로그아웃 하시겠어요?", "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!", "로그아웃"), ("정말 회원탈퇴 하시겠어요?", "아쉽지만 다음에 기회가 된다면 다시 Boarding을 찾아주세요!", "회원탈퇴")])
    
    var currentNonce: String?
    
    let errorCatch = PublishRelay<Bool>()
    let processCompleted = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        Observable.zip(deleteUserSubject, deleteUserImageSubject, deleteProfileSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - LogOut
    func logOut() {
        if AuthApi.hasToken() {
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
        if AuthApi.hasToken() {
            //카카오 계정삭제
            UserApi.shared.rx.unlink()
                .subscribe(onCompleted: { [weak self] in
                    guard let currentUser = Auth.auth().currentUser else { return }
                    self?.deleteUserImage(uid: currentUser.uid)
                    self?.deleteProfile(uid: currentUser.uid)
                    self?.deleteUser()
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
        let user = Auth.auth().currentUser
        user?.delete { [weak self] error in
            if let error = error {
                print("유저 계정 삭제 에러: \(error)")
            } else {
                print("계정 삭제 성공")
                self?.deleteUserSubject.onNext(())
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
            
            let nonce = currentNonce!
            let tokenData = appleIDCredential.identityToken!
            let token = String(data: tokenData, encoding: .utf8)!
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: token, rawNonce: nonce)
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
                        }
                    }
                }
            }
        }
    }
}
