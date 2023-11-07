//
//  HomeViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/27.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class HomeViewModel {
    
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        getAllNFT()
    }
    
    func getAllNFT() {
        db.collection("NFT").getDocuments { (querySnapshot, error) in
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
    
    func getAuther(auther: String, handler: @escaping (User) -> ()) {
        db.collection("User").document(auther).getDocument { (document, error) in
            if let error = error {
                print("글쓴이 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    handler(user)
                }
            }
        }
    }
}
