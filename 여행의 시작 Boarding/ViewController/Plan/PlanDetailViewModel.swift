//
//  PlanDetailViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/16.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class PlanDetailViewModel {
    
    var userUid = ""
    var planID = ""
    let items = BehaviorRelay<[NFT]>(value: [NFT]())
    let itemCount = BehaviorRelay<Int>(value: 0)
    var memo = BehaviorRelay<[String]>(value: [String]())
    let deleteCompleted = PublishSubject<Void>()
    
    init(planID: String) {
        if let user = Auth.auth().currentUser {
            self.userUid = user.uid
            self.planID = planID
            getMyDayPlan(day: "day1")
        }
    }
    
    func getMyDayPlan(day: String) {
        db.collection("User").document(userUid).collection("Plan").document(planID).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                print("DayPlan 불러오기 에러: \(error)")
            } else {
                if let document = documentSnapshot, document.exists {
                    var dayArray = document.get(day) as? [String] ?? [""]
                    if dayArray.isEmpty { dayArray = [""] }
                    var dayMemoArray = document.get("\(day)Memo") as? [String] ?? [""]
                    if dayMemoArray.isEmpty { dayMemoArray = [""] }
                    self.getNFT(dayArray: dayArray, dayMemoArray: dayMemoArray)
                }
            }
        }
    }
    
    func getNFT(dayArray: [String], dayMemoArray: [String]) {
        db.collection("NFT").whereField("NFTID", in: dayArray).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("NFT 불러오기 에러: \(error)")
            } else {
                var items = Array(repeating: NFT.dummyType, count: dayArray.count)
                for document in querySnapshot!.documents {
                    let NFT = document.makeNFT()
                    if let index = dayArray.firstIndex(of: NFT.NFTID) {
                        items[index] = NFT
                    }
                }
                
                //삭제된 NFT가 포함되어있을 때 dayPlan에서 삭제
                for (index, item) in items.enumerated() where item.NFTID == "" {
                    let memoArray = dayMemoArray.enumerated().filter { $0.offset != index }.map { $0.element }
                    self.removeDayPlan(NFTID: dayArray[index], memoArray: memoArray)
                }
                items.removeAll { $0.NFTID == "" }
                
                self.memo.accept(dayMemoArray)
                self.items.accept(items)
                self.itemCount.accept(items.count)
            }
        }
    }
    
    func geocodingUrl(_ latitude: Double, _ longitude: Double) -> URL? {
        let baseUrl = "https://maps.googleapis.com/maps/api/geocode/json"
        let location = "\(latitude),\(longitude)"
        let key = APIKey.googleMap
        let urlString = "\(baseUrl)?latlng=\(location)&key=\(key)"
        return URL(string: urlString)
    }
    
    func getAddress(latitude: Double, longitude: Double, _ handler: @escaping (String) -> Void) {
        if let url = geocodingUrl(latitude, longitude) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("dataTask error: \(error)")
                } else if let data = data {
                    let decoder = JSONDecoder()
                    if let json = try? decoder.decode(Geo.self, from: data) {
                        if let firstResult = json.results.first {
                            let address = firstResult.formatted_address
                            DispatchQueue.main.async {
                                handler(address)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func removeDayPlan(NFTID: String, memoArray: [String]) {
        db.collection("User").document(userUid).collection("Plan").document(planID)
            .updateData(["day1": FieldValue.arrayRemove([NFTID]), "day1Memo": memoArray]) {
            error in
            if let error = error {
                print("dayPlan 삭제 에러: \(error)")
            } else {
                print("dayPlan 삭제 성공")
            }
        }
    }
    
    func swapDayPlan(dayArray: [String], memoArray: [String]) {
        db.collection("User").document(userUid).collection("Plan").document(planID)
            .updateData(["day1": dayArray, "day1Memo": memoArray]) { error in
            if let error = error {
                print("dayPlan 순서 변경 에러: \(error)")
            } else {
                print("dayPlan 순서 변경 성공")
            }
        }
    }
    
    func deletePlan(planID: String) {
        guard let user = Auth.auth().currentUser else { return }
        db.collection("User").document(user.uid).collection("Plan").document(planID).delete() { error in
            if let error = error {
                print("NFT 삭제 에러: \(error)")
            } else {
                self.deleteCompleted.onNext(())
            }
        }
    }
}
