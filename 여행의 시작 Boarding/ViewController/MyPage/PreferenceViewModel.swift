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

class PreferenceViewModel {
    
//    let user = BehaviorRelay<KakaoSDKUser.User?>(value: nil)
    
    var token = BehaviorRelay<String?>(value: nil)
    let disposeBag = DisposeBag()
    
    init() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess: { user in
//                self.user.accept(user)
                self.token
                    .accept(String(user.id ?? 0))
                
                
                
                
            }, onFailure: { error in
                print("error \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoLogout() {
        UserApi.shared.logout{ error in
            if let error = error {
                print(error)
            } else {
                print("로그아웃 성공")
            }
        }
    }
}
