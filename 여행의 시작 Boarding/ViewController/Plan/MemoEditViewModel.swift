//
//  MemoEditViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/08.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class MemoEditViewModel {
    
    var userUid = ""
    var planID = ""
    
    init(planID: String) {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            self.planID = planID
        }
    }
    
    func editMemo(day: String, memoArray: [String]) {
        db.collection("User").document(userUid).collection("Plan").document(planID).updateData(["\(day)Memo": memoArray]) { error in
            if let error = error {
                print("memo 수정 에러: \(error)")
            } else {
                print("memo 수정 성공")
            }
        }
    }
}
