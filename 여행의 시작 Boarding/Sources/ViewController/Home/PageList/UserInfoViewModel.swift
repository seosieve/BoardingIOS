//
//  UserInfoViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/28.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth

class UserInfoViewModel {
    var userUid = ""
    let thumbnail = BehaviorRelay<URL?>(value: nil)
    let username = BehaviorRelay<String?>(value: nil)
    let introduce = BehaviorRelay<String?>(value: nil)
    
    init() {
        if let user = Auth.auth().currentUser {
            guard let photoURL = user.photoURL else { return }
            guard let nickname = user.displayName else { return }
            self.userUid = user.uid
            self.thumbnail.accept(photoURL)
            self.username.accept(nickname)
            getIntroduce()
        }
    }
    
    func getIntroduce() {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("유저 소개글 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    self.introduce.accept(user.introduce)
                }
            }
        }
    }
}
