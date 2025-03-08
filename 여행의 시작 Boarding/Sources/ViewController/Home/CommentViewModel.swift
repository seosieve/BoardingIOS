//
//  CommentViewModel.swift
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

class CommentViewModel {
    
    var listener: ListenerRegistration?
    
    var NFTID = ""
    var userUid = ""
    let thumbnail = BehaviorRelay<URL?>(value: nil)
    
    let users = BehaviorRelay<[User]>(value: [User.dummyType])
    let items = BehaviorRelay<[Comment]>(value: [Comment.dummyType])
    let itemCount = BehaviorRelay<Int>(value: 1)
    
    let writeCommentSubject = PublishSubject<Void>()
    let addCommentCountSubject = PublishSubject<Void>()
    let deleteCommentSubject = PublishSubject<Void>()
    let reduceCommentCountSubject = PublishSubject<Void>()
    let processCompleted = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    init(NFTID: String) {
        if let user = Auth.auth().currentUser {
            if let photoURL = user.photoURL {
                thumbnail.accept(photoURL)
            }
            self.userUid = user.uid
            self.NFTID = NFTID
            getAllCommentByDate()
        }
        
        Observable.zip(writeCommentSubject, addCommentCountSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
        
        Observable.zip(deleteCommentSubject, reduceCommentCountSubject)
            .map{ _ in return }
            .subscribe(onNext: { [weak self] in
                self?.processCompleted.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func getAllCommentByDate() {
        listener = db.collection("NFT").document(NFTID).collection("Comment").order(by: "writtenDate").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Comment 불러오기 에러: \(error)")
            } else {
                var items = [Comment]()
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let comment = document.makeComment()
                    items.append(comment)
                    authors.append(comment.authorUid)
                }
                self.getAuthors(authors: authors) { users in
                    self.users.accept(users)
                    self.items.accept(items)
                    self.itemCount.accept(items.count)
                }
            }
        }
    }
    
    func getAllCommentByLikes() {
        listener = db.collection("NFT").document(NFTID).collection("Comment").order(by: "likes", descending: true).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Comment 불러오기 에러: \(error)")
            } else {
                var items = [Comment]()
                var authors = [String]()
                for document in querySnapshot!.documents {
                    let comment = document.makeComment()
                    items.append(comment)
                    authors.append(comment.authorUid)
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
    
    func getTime(_ writtenDate: Double) -> String {
        let currentTime = Date().timeIntervalSince1970 + 1
        let time = Int((currentTime - writtenDate)/60)
        
        if time >= 1440 {
            return "\(time/1440)일 전"
        } else if time >= 60 {
            return "\(time/60)시간 전"
        } else if time > 0 {
            return "\(time)분 전"
        } else {
            return "\(Int((currentTime - writtenDate)))초 전"
        }
    }
    
    func writeComment(content: String) {
        let writtenDate = NSDate().timeIntervalSince1970
        let commentID = db.collection("NFT").document(NFTID).collection("Comment").document().documentID
        let comment = Comment(commentID: commentID, authorUid: userUid, writtenDate: writtenDate, content: content, likes: 0, likedPeople: [])
        db.collection("NFT").document(NFTID).collection("Comment").document(commentID).setData(comment.dicType) { error in
            if let error = error {
                print("comment 저장 에러: \(error)")
            } else {
                print("comment 저장 성공: \(commentID)")
                self.writeCommentSubject.onNext(())
            }
        }
    }
    
    func addCommentCount() {
        db.collection("NFT").document(NFTID).updateData(["comments": FieldValue.increment(Int64(1))]) { error in
            if let error = error {
                print("reports count 증가 에러: \(error)")
            } else {
                print("reports count 증가 성공")
                self.addCommentCountSubject.onNext(())
            }
        }
    }
    
    func deleteComment(commentID: String) {
        db.collection("NFT").document(NFTID).collection("Comment").document(commentID).delete() { error in
            if let error = error {
                print("comment 삭제 에러: \(error)")
            } else {
                self.deleteCommentSubject.onNext(())
            }
        }
    }
    
    func reduceCommentCount() {
        db.collection("NFT").document(NFTID).updateData(["comments": FieldValue.increment(Int64(-1))]) { error in
            if let error = error {
                print("reports count 감소 에러: \(error)")
            } else {
                print("reports count 감소 성공")
                self.reduceCommentCountSubject.onNext(())
            }
        }
    }
    
    func like(commentID: String) {
        let ref = db.collection("NFT").document(NFTID).collection("Comment").document(commentID)
        ref.getDocument { (document, error) in
            if let error = error {
                print("comment 불러오기 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let comment = document.makeComment()
                    let likedPeople = comment.likedPeople
                    if likedPeople.contains(self.userUid) {
                        ref.updateData(["likedPeople": FieldValue.arrayRemove([self.userUid])])
                        ref.updateData(["likes": FieldValue.increment(Int64(-1))])
                    } else {
                        ref.updateData(["likedPeople": FieldValue.arrayUnion([self.userUid])])
                        ref.updateData(["likes": FieldValue.increment(Int64(1))])
                    }
                }
            }
        }
    }
}
