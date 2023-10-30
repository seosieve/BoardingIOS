//
//  SplashViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/27.
//

import Foundation
import RxSwift
import RxCocoa
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import FirebaseAuth

class SplashViewModel {
    
    let isUserLoggedIn = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    func checkCurrentUser() {
        let user = Auth.auth().currentUser
        if let user = user {
            isUserLoggedIn.accept(true)
            print("현재 로그인된 유저는 \(user)")
        } else {
            isUserLoggedIn.accept(false)
        }
    }
}
