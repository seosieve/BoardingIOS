//
//  WrittingViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/06.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

class WrittingViewModel {
    let db = Firestore.firestore()
    let NFTID = Firestore.firestore().collection("NFT").document().documentID
    
    let location = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let weather = BehaviorRelay<String>(value: "")
    let title = BehaviorRelay<String>(value: "")
    let mainText = BehaviorRelay<String>(value: "")
    let starPoint = BehaviorRelay<Int>(value: 0)
    let category = BehaviorRelay<String>(value: "")
    
    let dataValid: Observable<Bool>
    
    init() {
        dataValid = Observable.combineLatest(title, mainText)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .distinctUntilChanged()
    }
    
    func NFTWrite() {
        let NFT = NFT(NFTID: NFTID, auther: "", autherEmail: "", type: "", url: "", location: "", time: "", weather: "", temperature: "", title: title.value, mainText: mainText.value, starPoint: starPoint.value, category: "", comments: 0, likes: 0, saves: 0, reports: 0)
        NFTSave(NFT: NFT)
    }
    
    func NFTSave(NFT: NFT) {
        db.collection("NFT").document(NFTID).setData(NFT.dicType) { error in
            if let error = error {
                print("NFT 저장 에러: \(error)")
            } else {
                print("NFT 저장 성공: \(self.NFTID)")
            }
        }
    }
}
