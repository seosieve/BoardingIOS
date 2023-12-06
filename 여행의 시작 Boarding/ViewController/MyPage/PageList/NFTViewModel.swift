//
//  NFTViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class NFTViewModel {
    
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    init() {
        if let user = Auth.auth().currentUser {
            getMyNFT(userUid: user.uid)
        }
    }
    
    func getMyNFT(userUid: String) {
        db.collection("NFT").whereField("authorUid", isEqualTo: userUid).order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("NFT 불러오기 에러: \(err)")
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
}
