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
    
    func addPlan(planID: String, NFTID: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).updateData(["day1": FieldValue.arrayUnion([NFTID])]) { error in
            if let error = error {
                print("reports count 증가 에러: \(error)")
            } else {
                print("reports count 증가 성공")
//                self.addReportCountSubject.onNext(())
            }
        }
    }
    
    func getDayPlan(planID: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).getDocument { (document, error) in
            if let error = error {
                print("Plan 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let day1 = document.get("day1") as! [String]?
                    print(day1)
                }
            }
        }
    }
}
