//
//  PlanDetailViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/16.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class PlanDetailViewModel {
    
    let deleteCompleted = PublishSubject<Void>()
    
    func deletePlan(planID: String) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("User").document(user.uid).collection("Plan").document(planID).delete() { error in
            if let error = error {
                print("NFT 삭제 에러: \(error)")
            } else {
                self.deleteCompleted.onNext(())
            }
        }
    }
}
