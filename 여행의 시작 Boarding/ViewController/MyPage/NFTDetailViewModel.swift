//
//  NFTDetailViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore
import FirebaseStorage

class NFTDetailViewModel {
    
    let deleteCompleted = PublishSubject<Void>()
    
    let disposeBag = DisposeBag()
    
    func deleteNFT(NFTID: String) {
        deleteImage(NFTID: NFTID) {
            db.collection("NFT").document(NFTID).delete() { error in
                if let error = error {
                    print("NFT 삭제 에러: \(error)")
                } else {
                    self.deleteCompleted.onNext(())
                }
            }
        }
    }
    
    func deleteImage(NFTID: String, completion: @escaping () -> Void) {
        let imageRef = ref.child("NFTImage/\(NFTID)")
        imageRef.delete { error in
            if let error = error {
                print("이미지 삭제 에러: \(error)")
            } else {
                completion()
            }
        }
    }
}
