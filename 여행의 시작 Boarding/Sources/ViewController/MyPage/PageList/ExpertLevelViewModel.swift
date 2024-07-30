//
//  ExpertLevelViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/10/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class ExpertLevelViewModel {
    
    var userUid = ""
    let travelLevel = BehaviorSubject<[Int]>(value: [])
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getTravelLevel()
        }
    }
    
    func getTravelLevel() {
        db.collection("User").document(userUid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("유저 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let user = document.makeUser()
                    self.travelLevel.onNext(user.travelLevel)
                }
            }
        }
    }
}
