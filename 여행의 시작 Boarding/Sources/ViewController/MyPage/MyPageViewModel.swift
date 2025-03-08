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
    var userUid = ""
    let photoURL = BehaviorRelay<URL?>(value: nil)
    let username = BehaviorRelay<String?>(value: nil)
    let introduce = BehaviorRelay<String?>(value: nil)
    
    init() {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            getMyInfo()
        }
    }
    
    func getMyInfo() {
        db.collection("User").document(userUid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("유저 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let user = document.makeUser()
                    self.photoURL.accept(URL(string:user.url))
                    self.username.accept(user.name)
                    self.introduce.accept(user.introduce)
                }
            }
        }
    }
}
