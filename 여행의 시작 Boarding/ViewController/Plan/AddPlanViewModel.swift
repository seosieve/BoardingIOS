//
//  AddPlanViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/01.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddPlanViewModel {
    
    var userUid = ""
    
    init() {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
        }
    }
    
    func addDayPlan(planID: String, NFTID: String) {
        let ref = db.collection("User").document(userUid).collection("Plan").document(planID)
        ref.getDocument { (document, error) in
            if let error = error {
                print("day 쿼리 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    var dayArray = document.get("day1") as? [String] ?? []
                    if !dayArray.contains(NFTID) { dayArray.append(NFTID) }
                    ref.updateData(["day1": dayArray]) { error in
                        if let error = error {
                            print("dayPlan 추가 에러: \(error)")
                        } else {
                            print("dayPlan 추가 성공")
                        }
                    }
                }
            }
        }
    }
}
