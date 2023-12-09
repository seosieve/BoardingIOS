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
    
    let addScrapSubject = PublishSubject<Void>()
    let addSaveCountSubject = PublishSubject<Void>()
    let processCompleted = PublishSubject<Void>()
    let items = BehaviorRelay<[Plan]>(value: Array(repeating: Plan.dummyType, count: 1))
    let itemCount = PublishRelay<Int>()
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getAllPlan(userUid: user.uid)
        }
        
        Observable.zip(addScrapSubject, addSaveCountSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
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
    
    func findScrap(planID: String, NFTID: String, _ handler: @escaping (Bool) -> Void) {
        db.collection("User").document(userUid).collection("Plan").document(planID).getDocument { (document, error) in
            if let error = error {
                print("scrap 탐색 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let plan = document.makePlan()
                    if plan.scrap.contains(NFTID) {
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            }
        }
    }
    
    func addScrap(planID: String, NFTID: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).updateData(["scrap": FieldValue.arrayUnion([NFTID])]) { error in
            if let error = error {
                print("scrap 추가 에러: \(error)")
            } else {
                print("scrap 추가 성공")
                self.addScrapSubject.onNext(())
            }
        }
    }
    
    func addSaveCount(NFTID: String) {
        db.collection("NFT").document(NFTID).updateData(["saves": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("save count 증가 에러: \(error)")
            } else {
                print("save count 증가 성공")
                self.addSaveCountSubject.onNext(())
            }
        }
    }
}
