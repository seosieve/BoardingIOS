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
    
    var userUid = ""
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
        }
        getAllNFT()
    }
    
    func getAllNFT() {
        db.collection("NFT").order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
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
    
    func getAuthor(author: String, handler: @escaping (User) -> ()) {
        db.collection("User").document(author).getDocument { (document, error) in
            if let error = error {
                print("글쓴이 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    DispatchQueue.main.async {
                        handler(user)
                    }
                }
            }
        }
    }
    
    func getNFTbyCategory(_ category: String) {
        db.collection("NFT").whereField("category", isEqualTo: category).order(by: "writtenDate", descending: true).getDocuments { (querySnapshot, error) in
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
    
    func getNFTbyWord(_ word: String) {
        db.collection("NFT").order(by: "writtenDate", descending: true).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if NFT.title.contains(word) || NFT.content.contains(word) {
                        items.append(NFT)
                    }
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
    
    func getNFTbyLocation(_ city: String) {
        db.collection("NFT").whereField("city", isEqualTo: city).order(by: "writtenDate", descending: true).getDocuments { (querySnapshot, error) in
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
