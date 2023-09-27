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

class SignUpViewModel {
    
    let errorCatch = PublishRelay<Bool>()
    let signUpResult = PublishRelay<Bool>()
    
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
                    self?.createUser(email: email, password: String(password))
                } else {
                    self?.errorCatch.accept(true)
                }
                
                //추후에 닉네임, 사진 받아서 firebase에 넣기
                let nickname = user.kakaoAccount?.profile?.nickname
                
            }, onFailure: { [weak self] error in
                self?.errorCatch.accept(true)
                print("카카오 유저 정보 불러오기 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error as? AuthErrorCode.Code {
//                switch error {
//                case .emailAlreadyInUse:
//                    // 이미 가입된 유저가 있을 때
//                    print("릴레이 하나 더 만들어서 에러처리해라")
//                default:
//                    print("파이어베이스 유저 생성 오류: \(error)")
//                }
                //에러 핸들링 다르게하기: 이미 가입된 유저가 있습니다.
                self?.errorCatch.accept(true)
            } else if let authResult = authResult {
                self?.signUpResult.accept(true)
                print("유저 생성 성공: \(authResult)")
            }
        }
    }
    
    func createUser2(email: String, password: String, createUserHandler: @escaping (String?) -> ()) {
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
