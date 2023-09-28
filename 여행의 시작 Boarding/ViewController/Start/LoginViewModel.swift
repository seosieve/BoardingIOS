//
//  LogInViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/19.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import FirebaseAuth

class LogInViewModel {
    
    let errorCatch = PublishRelay<Bool>()
    let userNotExist = PublishRelay<Bool>()
    let logInResult = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    func kakaoLogIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오톡(APP) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(true)
                    print("카카오계정(WEB) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func kakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess:{ [weak self] user in
                if let email = user.kakaoAccount?.email, let password = user.id {
                    self?.signInUser(email: email, password: String(password))
                } else {
                    self?.errorCatch.accept(true)
                }
            }, onFailure: { [weak self] error in
                self?.errorCatch.accept(true)
                print("카카오 유저 정보 불러오기 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                let code = (error as NSError).code
                switch code {
//                case 17007:
//                    // FIRAuthErrorCodeUserNotFound으로 다시 에러처리하기!!
//                    self?.userAlreadyExist.accept(true)
                default:
                    self?.errorCatch.accept(true)
                }
            } else if let authResult = authResult {
                self?.logInResult.accept(true)
                print("유저 로그인 성공: \(authResult)")
            }
        }
    }
}
