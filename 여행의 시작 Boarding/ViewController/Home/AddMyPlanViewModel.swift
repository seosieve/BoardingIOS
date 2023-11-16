//
//  AddMyPlanViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/16.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AddMyPlanViewModel {
    var userUid = ""
    
    let items = BehaviorRelay<[Plan]>(value: Array(repeating: Plan.dummyType, count: 1))
    let itemCount = PublishRelay<Int>()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getAllPlan(userUid: user.uid)
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
    
    func addScrap(planID: String, NFTID: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).updateData(["scrap": FieldValue.arrayUnion([NFTID])]) { error in
            if let error = error {
                print("scrap 추가 에러: \(error)")
            } else {
                print("scrap 추가 성공")
            }
        }
    }
}
