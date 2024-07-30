//
//  BlockedUserViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/05.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class BlockedUserViewModel {
    
    var userUid = ""
    let items = BehaviorRelay<[String]>(value: [""])
    let itemCount = PublishRelay<Int>()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getBlockedUser()
        }
    }
    
    func getBlockedUser() {
        db.collection("User").document(userUid).addSnapshotListener { (document, error) in
            if let error = error {
                print("유저 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    self.items.accept(user.blockedUser)
                    self.itemCount.accept(user.blockedUser.count)
                }
            }
        }
    }
    
    func makeBlockedUser(userUid: String, _ handler: @escaping (User) -> Void) {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("글쓴이 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    DispatchQueue.main.async {
                        handler(user)
                    }
                }
            }
        }
    }
    
    func unblockUser(target: String) {
        db.collection("User").document(userUid).updateData(["blockedUser": FieldValue.arrayRemove([target])]) { error in
            if let error = error {
                print("blockedUser 삭제 에러: \(error)")
            } else {
                print("blockedUser 삭제 성공")
            }
        }
    }
}
