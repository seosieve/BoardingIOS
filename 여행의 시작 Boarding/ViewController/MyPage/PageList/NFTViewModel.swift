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
    
    var listener: ListenerRegistration?
    
    var userUid = ""
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    init() {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            getMyNFTByDate()
        }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func getMyNFTByDate() {
        listener = db.collection("NFT").whereField("authorUid", isEqualTo: userUid).order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
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
    
    func getMyNFTByLikes() {
        listener = db.collection("NFT").whereField("authorUid", isEqualTo: userUid).order(by: "likes", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
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
