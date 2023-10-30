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
    let db = Firestore.firestore()
    
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            getMyNFT(userUid: user.uid)
        }
    }
    
    func getMyNFT(userUid: String) {
        db.collection("NFT").whereField("autherUid", isEqualTo: userUid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("NFT 불러오기 오류: \(err)")
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
