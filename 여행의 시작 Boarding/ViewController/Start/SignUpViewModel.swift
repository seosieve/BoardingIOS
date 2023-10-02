//
//  SignUpViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/15.
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

class SignUpViewModel: NSObject {
    var currentNonce: String?
    let userAlreadyExist = PublishRelay<Bool>()
    
    let errorCatch = PublishRelay<Bool>()
    let signUpResult = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
}

//MARK: - Apple SignUp
extension SignUpViewModel {    
    func appleLogIn() {
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

extension SignUpViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = currentNonce!
            let tokenData = appleIDCredential.identityToken!
            let token = String(data: tokenData, encoding: .utf8)!
            let credential = OAuthProvider.appleCredential(withIDToken: token, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                if let error = error {
                    print(error)
                    self?.errorCatch.accept(true)
                } else {
                    let fullName = appleIDCredential.fullName!
                    let displayName = [fullName.givenName, fullName.familyName].compactMap{$0}.joined()
                    if displayName == "" {
                        //로그아웃 후 애플로그인 할 때
                        self?.signUpResult.accept(true)
                    } else {
                        //처음 애플로그인 할 때
                        self?.makeProfile(nickname: displayName, thumbnail: URL(string: "https://t3.ftcdn.net/jpg/00/64/67/52/360_F_64675209_7ve2XQANuzuHjMZXP3aIYIpsDKEbF5dD.jpg")!)
                    }
                    print("유저 로그인 성공")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //X버튼 누를때도 실행되기 때문에 에러처리 안했음
        self.signUpResult.accept(false)
        print("애플 로그인 에러: \(error.localizedDescription)")
    }
}

//MARK: - Kakao SignUp
extension SignUpViewModel {
    func kakaoLogIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(false)
                    print("카카오톡(APP) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(false)
                    print("카카오계정(WEB) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func kakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess:{ [weak self] user in
                if let email = user.kakaoAccount?.email, let password = user.id, let nickname = user.kakaoAccount?.profile?.nickname, let thumbnail = user.kakaoAccount?.profile?.profileImageUrl {
                    self?.createUser(email: email, password: String(password), nickname: nickname, thumbnail: thumbnail)
                } else {
                    self?.errorCatch.accept(true)
                }
            }, onFailure: { [weak self] error in
                self?.errorCatch.accept(true)
                print("카카오 유저 정보 불러오기 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func createUser(email: String, password: String, nickname: String, thumbnail: URL) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007:
                    // 이미 가입된 유저가 있을 때
                    self?.userAlreadyExist.accept(true)
                default:
                    self?.errorCatch.accept(true)
                    print("파이어베이스 유저 생성 오류: \(error)")
                }
            } else if let authResult = authResult {
                self?.makeProfile(nickname: nickname, thumbnail: thumbnail)
                print("유저 생성 성공: \(authResult)")
            }
        }
    }
    
    func makeProfile(nickname: String, thumbnail: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nickname
        changeRequest?.photoURL = thumbnail
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                self?.errorCatch.accept(true)
                print("파이어베이스 프로필 생성 오류: \(error)")
            } else {
                self?.signUpResult.accept(true)
                print("파이어베이스 프로필 생성 성공")
            }
        }
    }
}
