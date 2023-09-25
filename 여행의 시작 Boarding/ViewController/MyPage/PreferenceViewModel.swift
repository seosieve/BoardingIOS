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
    
    let token = BehaviorRelay<String?>(value: nil)
    let email = BehaviorRelay<String?>(value: nil)
    let nickname = BehaviorRelay<String?>(value: nil)
    
    let items = BehaviorRelay<[String]>(value: ["이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"])
    let selectedItemIndex = PublishSubject<Int>()
    let KakaoLogOutCompleted = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()

    init() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess:{ [weak self] user in
                self?.token.accept(String((user.id) ?? 0))
                self?.email.accept(user.kakaoAccount?.email)
                self?.nickname.accept(user.kakaoAccount?.profile?.nickname)
            }, onFailure: { error in
                print("유저 정보 불러오기 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    
    func kakaoLogOut() {
        UserApi.shared.rx.logout()
            .subscribe(onCompleted: { [weak self] in
                self?.KakaoLogOutCompleted.accept(true)
            }, onError: { [weak self] error in
                self?.KakaoLogOutCompleted.accept(true)
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
