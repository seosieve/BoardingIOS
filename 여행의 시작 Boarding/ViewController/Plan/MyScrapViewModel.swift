//
//  MyScrapViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/30.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class MyScrapViewModel {
    
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    init(planID: String) {
        if let user = Auth.auth().currentUser {
            let userUid = user.uid
            getMyScrap(userUid: userUid, planID: planID)
        }
    }
    
    func getMyScrap(userUid: String, planID: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).addSnapshotListener { (documentSnapshot, err) in
            if let err = err {
                print("Plan 불러오기 에러: \(err)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let plan = document.makePlan()
                    let scarp = plan.scrap.isEmpty ? [""] : plan.scrap
                    self.getScrapNFT(scrap: scarp)
                }
            }
        }
    }
    
    func getScrapNFT(scrap: [String]) {
        db.collection("NFT").whereField("NFTID", in: scrap).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("scrap 불러오기 에러: \(err)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    items.append(NFT)
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
    
    func deleteScrap(planID: String, NFTID: String) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("User").document(user.uid).collection("Plan").document(planID).updateData(["scrap": FieldValue.arrayRemove([NFTID])]) { error in
            if let error = error {
                print("scrap 삭제 에러: \(error)")
            } else {
                print("scrap 삭제 성공")
            }
        }
    }
}
