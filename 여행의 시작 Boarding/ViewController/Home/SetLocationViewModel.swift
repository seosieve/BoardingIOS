//
//  SetLocationViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/22.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SetLocationViewModel {
    let items = BehaviorRelay<[Location]>(value: Array(repeating: Location.dummyType, count: 1))
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        getAllLocation()
    }
    
    func getAllLocation() {
        db.collection("NFT").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var dictionary = [String: (Int, String)]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    let count = dictionary["\(NFT.country),\(NFT.city)", default: (0, "")]
                    dictionary["\(NFT.country),\(NFT.city)"] = (count.0 + 1, NFT.url)
                }
                
                var items = [Location]()
                for dic in dictionary {
                    let location = dic.key.split(separator: ",").map{String($0)}
                    items.append(Location(url: dic.value.1, country: location[0], city: location[1], count: dic.value.0))
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
}
