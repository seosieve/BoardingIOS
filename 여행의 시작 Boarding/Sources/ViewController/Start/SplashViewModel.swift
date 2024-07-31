//
//  SplashViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/27.
//

import Foundation
import RxSwift
import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser

final class SplashViewModel: BaseViewModel {
    
    typealias FirebaseUser = FirebaseAuth.User
    
    let isUserLoggedIn = PublishSubject<Bool>()
    let loginType = PublishSubject<Names.LoginType>()
    
    private let disposeBag = DisposeBag()
    
    ///FireBase에서 현재 LogIn 상태인지를 확인
    func checkUserLoggedIn() {
        if let user = Auth.auth().currentUser {
            isUserLoggedIn.onNext(true)
            ///로그인 타입 확인
            checkLoginType(user: user)
        } else {
            isUserLoggedIn.onNext(false)
            print("로그인되어있지 않습니다.")
        }
    }
    
    ///User의 간편 로그인 타입 확인
    private func checkLoginType(user: FirebaseUser) {
        for userInfo in user.providerData {
            if userInfo.providerID == "apple.com" {
                loginType.onNext(.apple)
            } else {
                loginType.onNext(.kakao)
                checkAccessToken()
            }
        }
    }
    
    ///Kakao Access Token 확인 & 갱신
    func checkAccessToken() {
        guard AuthApi.hasToken() else { return }
        
        UserApi.shared.rx.accessTokenInfo()
            .subscribe(onSuccess: { value in
                ///Access Token 갱신, 남은 만료일 확인
                print("Access Token 만료기한: \(value.expiresIn) Millis")
            }, onFailure: { error in
                print("Access Token 에러: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
