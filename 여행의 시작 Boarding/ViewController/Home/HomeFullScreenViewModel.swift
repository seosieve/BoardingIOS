//
//  HomeFullScreenViewModel.swift
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

class HomeFullScreenViewModel {
    
    var userUid = ""
    var NFTID = ""
    var likeCount = BehaviorRelay<Int>(value: 0)
    var saveCount = BehaviorRelay<Int>(value: 0)
    var likedPeople = BehaviorRelay<[String]>(value: [])
    
    init(NFTID: String) {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            self.NFTID = NFTID
            interActionCountSnapshot()
        }
    }
    
    func likeAction() {
        db.collection("NFT").document(NFTID).getDocument { (document, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let NFT = document.makeNFT()
                    let likedPeople = NFT.likedPeople
                    if likedPeople.contains(self.userUid) {
                        db.collection("NFT").document(self.NFTID).updateData(["likedPeople": FieldValue.arrayRemove([self.userUid])])
                        db.collection("NFT").document(self.NFTID).updateData(["likes": FieldValue.increment(Int64(-1))])
                    } else {
                        db.collection("NFT").document(self.NFTID).updateData(["likedPeople": FieldValue.arrayUnion([self.userUid])])
                        db.collection("NFT").document(self.NFTID).updateData(["likes": FieldValue.increment(Int64(1))])
                    }
                }
            }
        }
    }
    
    func interActionCountSnapshot() {
        db.collection("NFT").document(NFTID).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let NFT = document.makeNFT()
                    self.likeCount.accept(NFT.likes)
                    self.saveCount.accept(NFT.saves)
                    self.likedPeople.accept(NFT.likedPeople)
                }
            }
        }
    }
}
