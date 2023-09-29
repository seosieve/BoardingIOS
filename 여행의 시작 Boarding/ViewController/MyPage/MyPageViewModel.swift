//
//  MyPageViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/29.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class MyPageViewModel {
    let thumbnail = PublishRelay<URL>()
    let username = PublishRelay<String>()
    
    func aa() {
        if let user = Auth.auth().currentUser {
            if let photoURL = user.photoURL, let nickname = user.displayName {
                thumbnail.accept(photoURL)
                username.accept(nickname)
            }
        } else {
            print("현재 로그인한 유저가 없습니다.")
        }
    }
}
