//
//  MILEViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/11/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class MILEViewModel {
 
    var userUid = ""
    let likes = BehaviorRelay<Int>(value: 0)
    let saves = BehaviorRelay<Int>(value: 0)
    let reports = BehaviorRelay<Int>(value: 0)
    let result = BehaviorRelay<Int>(value: 0)
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getMyNFT()
        }
    }
    
    func getMyNFT() {
        db.collection("NFT").whereField("authorUid", isEqualTo: userUid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var likes = 0
                var saves = 0
                var reports = 0
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    likes += NFT.likes * 100
                    saves += NFT.saves * 20
                    reports += NFT.reports * 7
                }
                self.likes.accept(likes)
                self.saves.accept(saves)
                self.reports.accept(reports)
                self.result.accept(likes + saves - reports)
            }
        }
    }
}
