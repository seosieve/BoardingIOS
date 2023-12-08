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
    var planID = ""
    var NFTID = ""
    
    init(planID: String, NFTID: String) {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            self.planID = planID
            self.NFTID = NFTID
        }
    }
    
    func addDayPlan(day: String, memo: String) {
        let ref = db.collection("User").document(userUid).collection("Plan").document(planID)
        ref.getDocument { (document, error) in
            if let error = error {
                print("day 쿼리 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    var dayArray = document.get(day) as? [String] ?? []
                    var dayMemoArray = document.get("\(day)Memo") as? [String] ?? []
                    
                    if !dayArray.contains(self.NFTID) {
                        dayArray.append(self.NFTID)
                        ref.updateData([day: dayArray]) { error in
                            if let error = error {
                                print("dayPlan 추가 에러: \(error)")
                            } else {
                                print("dayPlan 추가 성공")
                            }
                        }
                        dayMemoArray.append(memo)
                        ref.updateData(["\(day)Memo": dayMemoArray]) { error in
                            if let error = error {
                                print("dayPlanMemo 추가 에러: \(error)")
                            } else {
                                print("dayPlanMemo 추가 성공")
                            }
                        }
                    }
                }
            }
        }
    }
}
