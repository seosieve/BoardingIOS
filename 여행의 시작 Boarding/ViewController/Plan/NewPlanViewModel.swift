//
//  NewPlanViewModel.swift
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

class NewPlanViewModel {
    var planID = ""
    var userUid = ""
    
    var title = BehaviorRelay<String>(value: "")
    var location = BehaviorRelay<String>(value: "")
    var boarding = BehaviorRelay<String>(value: "")
    var landing = BehaviorRelay<String>(value: "")
    var days = BehaviorRelay<Int>(value: 0)
    var writtenDate = BehaviorRelay<Double>(value: 0)
    
    let dataValid: Observable<Bool>
    let writtingResult = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            planID = db.collection("User").document(user.uid).collection("Plan").document().documentID
        }
        
        dataValid = Observable.combineLatest(title, location, boarding, landing)
            .map{ $0.0 != Plan.placeHolder[0] && $0.1 != Plan.placeHolder[1] && $0.2 != Plan.placeHolder[2] && $0.3 != Plan.placeHolder[3]}
    }
    
    func planWrite() {
        let plan = Plan(planID: planID,
                        title: title.value,
                        location: location.value,
                        latitude: 0,
                        longitude: 0,
                        boarding: boarding.value,
                        landing:landing.value,
                        days: days.value,
                        writtenDate: writtenDate.value,
                        scrap: [String]())
        
        db.collection("User").document(userUid).collection("Plan").document(planID).setData(plan.dicType) { error in
            if let error = error {
                print("NFT 저장 에러: \(error)")
                self.writtingResult.accept(false)
            } else {
                print("NFT 저장 성공: \(self.planID)")
                self.writtingResult.accept(true)
            }
        }
    }
    
}
