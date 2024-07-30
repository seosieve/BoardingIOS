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
    var userProfileChanged = PublishSubject<Void>()
    let users = BehaviorRelay<[User]>(value: Array(repeating: User.dummyType, count: 10))
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
                    // 유저 프로필 변경되었을 때
                    self.userProfileChanged.onNext(())
                    self.blockdUser = user.blockedUser
                }
            }
        }
    }
    
    func getAllNFT() {
        db.collection("NFT").order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("모든 NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    //Blocked User 제외
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                        authors.append(NFT.authorUid)
                    }
                }
                self.getAuthors(authors: authors) { users in
                    self.users.accept(users)
                    self.items.accept(items)
                    self.itemCount.accept(items.count)
                }
            }
        }
    }
    
    func getAuthors(authors: [String], handler: @escaping ([User]) -> ()) {
        var users = Array(repeating: User.dummyType, count: authors.count)
        db.collection("User").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let user = document.makeUser()
                    let index = authors.enumerated().filter{ $0.element == user.userUid }.map{ $0.offset }
                    for index in index {
                        users[index] = user
                    }
                }
                handler(users)
            }
        }
    }
    
    func getVideoUrl(NFTID: String, _ handler: @escaping (URL) -> Void) {
        let videoRef = ref.child("NFTVideo/\(NFTID)")
        videoRef.downloadURL { (url, error) in
            if let error = error {
                print("VideoUrl 불러오기 에러: \(error)")
            } else {
                if let url = url {
                    handler(url)
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
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                        authors.append(NFT.authorUid)
                    }
                }
                self.getAuthors(authors: authors) { users in
                    self.users.accept(users)
                    self.items.accept(items)
                    self.itemCount.accept(items.count)
                }
            }
        }
    }
    
    func getNFTbyWord(_ word: String) {
        listener = db.collection("NFT").order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Word Sorted NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if NFT.title.contains(word) || NFT.content.contains(word) {
                        if !self.blockdUser.contains(NFT.authorUid) {
                            items.append(NFT)
                            authors.append(NFT.authorUid)
                        }
                    }
                }
                self.getAuthors(authors: authors) { users in
                    self.users.accept(users)
                    self.items.accept(items)
                    self.itemCount.accept(items.count)
                }
            }
        }
    }
    
    func getNFTbyLocation(_ city: String) {
        listener = db.collection("NFT").whereField("city", isEqualTo: city).order(by: "writtenDate", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var items = [NFT]()
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if !self.blockdUser.contains(NFT.authorUid) {
                        items.append(NFT)
                        authors.append(NFT.authorUid)
                    }
                }
                self.getAuthors(authors: authors) { users in
                    self.users.accept(users)
                    self.items.accept(items)
                    self.itemCount.accept(items.count)
                }
            }
        }
    }
    
    func like(NFTID: String) {
        db.collection("NFT").document(NFTID).getDocument { (document, error) in
            if let error = error {
                print("User 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let NFT = document.makeNFT()
                    let likedPeople = NFT.likedPeople
                    if likedPeople.contains(self.userUid) {
                        db.collection("NFT").document(NFTID).updateData(["likedPeople": FieldValue.arrayRemove([self.userUid])])
                        db.collection("NFT").document(NFTID).updateData(["likes": FieldValue.increment(Int64(-1))])
                    } else {
                        db.collection("NFT").document(NFTID).updateData(["likedPeople": FieldValue.arrayUnion([self.userUid])])
                        db.collection("NFT").document(NFTID).updateData(["likes": FieldValue.increment(Int64(1))])
                    }
                }
            }
        }   
    }
}
