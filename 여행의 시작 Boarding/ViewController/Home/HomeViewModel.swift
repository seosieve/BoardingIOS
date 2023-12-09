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
    
    var listener: ListenerRegistration?
    
    var userUid = ""
    var blockdUser = [String]()
    var blockedUserRemoved = PublishSubject<Void>()
    let items = BehaviorRelay<[NFT]>(value: Array(repeating: NFT.dummyType, count: 10))
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getBlockedUser()
        }
        getAllNFT()
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func getBlockedUser() {
        db.collection("User").document(userUid).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("유저 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    let user = document.makeUser()
                    // blockedUser 해제되었을때
                    if self.blockdUser.count > user.blockedUser.count {
                        self.blockedUserRemoved.onNext(())
                    }
                    self.blockdUser = user.blockedUser
                }
            }
        }
    }
    
    func getAllNFT() {
        listener = db.collection("NFT").order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("모든 NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                    }
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
        listener = db.collection("NFT").whereField("category", isEqualTo: category).order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Category Sorted NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                    }
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
    
    func getNFTbyWord(_ word: String) {
        listener = db.collection("NFT").order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Word Sorted NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if NFT.title.contains(word) || NFT.content.contains(word) {
                        if !self.blockdUser.contains(NFT.authorUid) {
                            items.append(NFT)
                        }
                    }
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
    
    func getNFTbyLocation(_ city: String) {
        listener = db.collection("NFT").whereField("city", isEqualTo: city).order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                    }
                }
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
}
