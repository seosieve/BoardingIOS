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
    let messageArr = BehaviorRelay<[(String, String, String)]>(value: [("정말 로그아웃 하시겠어요?", "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!", "로그아웃"), ("정말 회원탈퇴 하시겠어요?", "아쉽지만 다음에 기회가 된다면 다시 Boarding을 찾아주세요!", "회원탈퇴")])
    let processCompleted = PublishRelay<Bool>()
    
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
                self?.processCompleted.accept(true)
            }, onError: { [weak self] error in
                self?.processCompleted.accept(false)
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func kakaoUnLink() {
        UserApi.shared.rx.unlink()
            .subscribe(onCompleted: { [weak self] in
                self?.processCompleted.accept(true)
            }, onError: { [weak self] error in
                self?.processCompleted.accept(false)
                print(error)
            })
            .disposed(by: disposeBag)
    }
}
