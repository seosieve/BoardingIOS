//
//  RecordViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/26.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RecordViewModel {
    
    let pastTravelItems = BehaviorRelay<[(UIImage?, String, String)]>(value: [(UIImage(named: "France1"), "2024 뉴욕 여행", "미정"), (UIImage(named: "France1"), "여름방학 프랑스 여행", "23.07.10 ~ 23.07.25"), (UIImage(named: "France1"), "유럽 축구 여행", "파리, 프랑스")])
    let pastTravelItemCount = PublishRelay<Int>()
    let recordItems = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let recordItemCount = BehaviorRelay<Int>(value: 10)
    
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
                self.recordItems.accept(items)
                self.recordItemCount.accept(items.count)
            }
        }
    }
    
    func downloadVideo(urlString: String, _ handler: @escaping (UIImage) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        storageReference.downloadURL { url, error in
            if let error = error {
                print("동영상 url 다운로드 에러: \(error)")
            } else {
                if let url = url {
                    url.makeThumbnail(handler)
                }
            }
        }
    }
}
