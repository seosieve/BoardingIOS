//
//  PlanViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/10.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class PlanViewModel {
    
    let items = BehaviorRelay<[Plan]>(value: Array(repeating: Plan.dummyType, count: 1))
    let itemCount = PublishRelay<Int>()
    
    init() {
        if let user = Auth.auth().currentUser {
            let userUid = user.uid
            getAllPlan(userUid: userUid)
        }
    }
    
    func getAllPlan(userUid: String) {
        db.collection("User").document(userUid).collection("Plan").order(by: "writtenDate").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Plan 불러오기 에러: \(error)")
            } else {
                var items = [Plan]()
                for document in querySnapshot!.documents {
                    let plan = document.makePlan()
                    items.append(plan)
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
}
