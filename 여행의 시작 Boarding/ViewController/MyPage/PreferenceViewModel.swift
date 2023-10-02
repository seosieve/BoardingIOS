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
    
    let token = BehaviorRelay<String?>(value: nil)
    let email = BehaviorRelay<String?>(value: nil)
    let nickname = BehaviorRelay<String?>(value: nil)
    
    let items = BehaviorRelay<[String]>(value: ["이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"])
    let messageArr = BehaviorRelay<[(String, String, String)]>(value: [("정말 로그아웃 하시겠어요?", "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!", "로그아웃"), ("정말 회원탈퇴 하시겠어요?", "아쉽지만 다음에 기회가 된다면 다시 Boarding을 찾아주세요!", "회원탈퇴")])
    
    var currentNonce: String?
    
    let errorCatch = PublishRelay<Bool>()
    let processCompleted = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()

//    init() {
//        UserApi.shared.rx.me()
//            .subscribe(onSuccess:{ [weak self] user in
//                self?.token.accept(String((user.id) ?? 0))
//                self?.email.accept(user.kakaoAccount?.email)
//                self?.nickname.accept(user.kakaoAccount?.profile?.nickname)
//            }, onFailure: { error in
//                print("유저 정보 불러오기 오류: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
    
    //MARK: - LogOut
    func kakaoLogOut() {
        if AuthApi.hasToken() {
            UserApi.shared.rx.logout()
                .subscribe(onCompleted: { [weak self] in
                    self?.signOutUser()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오 로그아웃 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            self.signOutUser()
        }
    }
    
    func signOutUser() {
        do {
            try Auth.auth().signOut()
            processCompleted.accept(true)
            print("로그아웃 성공")
        } catch let error as NSError {
            errorCatch.accept(true)
            print("로그아웃 에러: \(error.localizedDescription)")
        }
    }
    
    //MARK: - DeleteUser
    func kakaoUnLink() {
        if AuthApi.hasToken() {
            UserApi.shared.rx.unlink()
                .subscribe(onCompleted: { [weak self] in
                    self?.deleteUser()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오 연결끊기 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            let currentUser = Auth.auth().currentUser
            currentUser!.unlink(fromProvider: "apple.com") { (result, error) in
                if let error = error {
                    // 탈퇴 실패
                    print("Unlink failed: \(error.localizedDescription)")
                } else {
                    // 탈퇴 성공
                    print("Unlink successful")
                    currentUser?.delete { [weak self] error in
                        if let error = error {
                            print("유저 계정 삭제 에러 : \(error)")
                        } else {
                            self?.processCompleted.accept(true)
                            print("계정 삭제 성공")
                        }
                    }
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
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { [weak self] error in
            if let error = error {
                print("유저 계정 삭제 에러 : \(error)")
            } else {
                self?.processCompleted.accept(true)
                print("계정 삭제 성공")
            }
        }
    }
}

extension PreferenceViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let _ = currentNonce!
            let appleAuthCode = appleIDCredential.authorizationCode!
            let authCodeString = String(data: appleAuthCode, encoding: .utf8)!
            
            Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
            self.deleteUser()
        }
    }
}
