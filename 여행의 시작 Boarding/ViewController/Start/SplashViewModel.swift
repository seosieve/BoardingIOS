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
    
    let isUserLoggedIn = BehaviorRelay<Bool>(value: false)
    
    func checkCurrentUser() {
        if let user = Auth.auth().currentUser {
            isUserLoggedIn.accept(true)
            print("현재 로그인된 유저는 \(user.displayName ?? "").")
        } else {
            isUserLoggedIn.accept(false)
            print("로그인되어있지 않습니다.")
        }
    }
    
    func test(input: [Int]) -> Int {
        let result = input.reduce(0,+)
        return result
    }
}
