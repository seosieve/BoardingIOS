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
    lazy var global = Location(url: Location.global, country: "", city: "전세계", count: globalCount)
    var globalCount = 0
    var userUid = ""
    var bookMark = [String]()
    
    let items = BehaviorRelay<[Location]>(value: [Location.dummyType])
    let itemCount = PublishRelay<Int>()
    
    let disposeBag = DisposeBag()
    
    init() {
        if let user = Auth.auth().currentUser {
            userUid = user.uid
            getUserBookMark { bookMark in
                self.bookMark = bookMark
                self.getAllLocation()
            }
        }
        
    }
    
    func getUserBookMark(handler: @escaping ([String]) -> ()) {
        db.collection("User").document(userUid).getDocument { (document, error) in
            if let error = error {
                print("유저 북마크 에러: \(error)")
            } else {
                if let document = document, document.exists {
                    let user = document.makeUser()
                    DispatchQueue.main.async {
                        handler(user.bookMark)
                    }
                }
            }
        }
    }
    
    func getAllLocation() {
        db.collection("NFT").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var dictionary = [String: (Int, String)]()
                for document in querySnapshot!.documents {
                    self.globalCount += 1
                    let NFT = document.makeNFT()
                    if NFT.country != "" && NFT.city != "" {
                        let count = dictionary["\(NFT.country),\(NFT.city)", default: (0, "")]
                        dictionary["\(NFT.country),\(NFT.city)"] = (count.0 + 1, NFT.url)
                    }
                }
                
                var bookMarkedItems = [Location]()
                var normalItems = [Location]()
                
                for dic in dictionary {
                    let location = dic.key.split(separator: ",").map{String($0)}
                    if self.bookMark.contains("\(location[0]) \(location[1])") {
                        bookMarkedItems.append(Location(url: dic.value.1, country: location[0], city: location[1], count: dic.value.0))
                    } else {
                        normalItems.append(Location(url: dic.value.1, country: location[0], city: location[1], count: dic.value.0))
                    }
                }
                
                bookMarkedItems.sort{ $0.count == $1.count ? $0.city > $1.city : $0.count > $1.count }
                normalItems.sort{ $0.count == $1.count ? $0.city > $1.city : $0.count > $1.count }
                
                self.items.accept([self.global] + bookMarkedItems + normalItems)
                self.itemCount.accept(1 + bookMarkedItems.count + normalItems.count)
            }
        }
    }
    
    func getSearchedLocation(search: String) {
        db.collection("NFT").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var dictionary = [String: (Int, String)]()
                for document in querySnapshot!.documents {
                    self.globalCount += 1
                    let NFT = document.makeNFT()
                    if NFT.country != "" && NFT.city != "" {
                        let count = dictionary["\(NFT.country),\(NFT.city)", default: (0, "")]
                        dictionary["\(NFT.country),\(NFT.city)"] = (count.0 + 1, NFT.url)
                    }
                }
                
                var bookMarkedItems = [Location]()
                var normalItems = [Location]()
                
                for dic in dictionary {
                    let location = dic.key.split(separator: ",").map{String($0)}
                    if location[0] == search || location[1].contains(search) {
                        if self.bookMark.contains("\(location[0]) \(location[1])") {
                            bookMarkedItems.append(Location(url: dic.value.1, country: location[0], city: location[1], count: dic.value.0))
                        } else {
                            normalItems.append(Location(url: dic.value.1, country: location[0], city: location[1], count: dic.value.0))
                        }
                    }
                }
                
                bookMarkedItems.sort{ $0.count == $1.count ? $0.city > $1.city : $0.count > $1.count }
                normalItems.sort{ $0.count == $1.count ? $0.city > $1.city : $0.count > $1.count }
                
                self.items.accept([self.global] + bookMarkedItems + normalItems)
                self.itemCount.accept(1 + bookMarkedItems.count + normalItems.count)
            }
        }
    }
    
    func addBookMark(country: String, city: String) {
        db.collection("User").document(userUid).updateData(["bookMark": FieldValue.arrayUnion(["\(country) \(city)"])]) { error in
            if let error = error {
                print("bookMark 추가 에러: \(error)")
            } else {
                self.bookMark.append("\(country) \(city)")
                print("bookMark 추가 성공")
            }
        }
    }
    
    func removeBookMark(country: String, city: String) {
        db.collection("User").document(userUid).updateData(["bookMark": FieldValue.arrayRemove(["\(country) \(city)"])]) { error in
            if let error = error {
                print("bookMark 삭제 에러: \(error)")
            } else {
                self.bookMark.removeAll { $0 == "\(country) \(city)" }
                print("bookMark 삭제 성공")
            }
        }
    }
}
