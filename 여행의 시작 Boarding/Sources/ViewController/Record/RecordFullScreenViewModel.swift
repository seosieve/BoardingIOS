//
//  RecordFullScreenViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/14/23.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class RecordFullScreenViewModel {
    
    var NFTID = ""
    let videoUrl = PublishRelay<URL>()
    
    init(NFT: NFT) {
        if let user = Auth.auth().currentUser {
            self.NFTID = NFT.NFTID
            if NFT.type == "video" {
                getVideoUrl()
            }
        }
    }
    
    func getVideoUrl() {
        let videoRef = ref.child("NFTVideo/\(NFTID)")
        videoRef.downloadURL { (url, error) in
            if let error = error {
                print("VideoUrl 불러오기 에러: \(error)")
            } else {
                if let url = url {
                    self.videoUrl.accept(url)
                }
            }
        }
    }
}
