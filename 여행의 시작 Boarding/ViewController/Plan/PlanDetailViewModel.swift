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
import FirebaseStorage

class PlanDetailViewModel {
    
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 1))
    let itemCount = PublishRelay<Int>()
    
    init(scrap: [String]) {
        if scrap.isEmpty {
            
        } else {
            getScrapNFT(scrap: scrap)
        }
    }
    
    func getScrapNFT(scrap: [String]) {
        db.collection("NFT").whereField("NFTID", in: scrap).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("scrap 불러오기 오류: \(err)")
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
