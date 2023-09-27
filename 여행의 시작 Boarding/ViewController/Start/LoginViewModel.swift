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
    
    let kakaoLogInCompleted = PublishRelay<Bool>()
    let disposeBag = DisposeBag()
    
    func kakaoLogIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ [weak self] _ in
                    self?.kakaoLogInCompleted.accept(true)
                }, onError: { [weak self] error in
                    self?.kakaoLogInCompleted.accept(false)
                    print("카카오톡(APP) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] _ in
                    self?.kakaoLogInCompleted.accept(true)
                }, onError: { [weak self] error in
                    self?.kakaoLogInCompleted.accept(false)
                    print("카카오계정(WEB) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func createUser(email: String, password: String, createUserHandler: @escaping (String?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                let errorString = error.localizedDescription
                createUserHandler(errorString)
            } else {
                createUserHandler(nil)
            }
        }
    }
}
