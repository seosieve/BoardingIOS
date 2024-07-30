//
//  BackendExtension.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/07.
//

import Foundation
import Photos
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI

//APIKey
struct APIKey {
    static let kakao = "a0dc7630ce25410d137528fcda8a9d30"
    static let googleMap = "AIzaSyAmNO6vhM_XtGzhOBksA7oqV3OIugSg5sM"
}

//Firestore DB
let db = Firestore.firestore()
let ref = Storage.storage().reference()

//MARK: - Apple LogIn Token
extension NSObject {
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Nonce 생성 에러: \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}

extension URL {
    func makeThumbnail(_ handler: @escaping (UIImage) -> Void) {
        let imageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
        imageGenerator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
            let thumbnailImage = UIImage(cgImage: cgImage)
            handler(thumbnailImage)
        } catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}

//MARK: - make NFT from Document
extension DocumentSnapshot {
    func makeNFT() -> NFT {
        let NFTID = self.get("NFTID") as! String
        let authorUid = self.get("authorUid") as! String
        let writtenDate = self.get("writtenDate") as! Double
        let type = self.get("type") as! String
        let url = self.get("url") as! String
        let videoUrl = self.get("videoUrl") as! String
        let location = self.get("location") as! String
        let country = self.get("country") as! String
        let city = self.get("city") as! String
        let latitude = self.get("latitude") as! Double
        let longitude = self.get("longitude") as! Double
        let time = self.get("time") as! String
        let weather = self.get("weather") as! String
        let title = self.get("title") as! String
        let content = self.get("content") as! String
        let starPoint = self.get("starPoint") as! Int
        let category = self.get("category") as! String
        let comments = self.get("comments") as! Int
        let likes = self.get("likes") as! Int
        let saves = self.get("saves") as! Int
        let reports = self.get("reports") as! Int
        let likedPeople = self.get("likedPeople") as! [String]
        
        let NFT = NFT(NFTID: NFTID,
                      authorUid: authorUid,
                      writtenDate: writtenDate,
                      type: type,
                      url: url,
                      videoUrl: videoUrl,
                      location: location,
                      country: country,
                      city: city,
                      latitude: latitude,
                      longitude: longitude,
                      time: time,
                      weather: weather,
                      title: title,
                      content: content,
                      starPoint: starPoint,
                      category: category,
                      comments: comments,
                      likes: likes,
                      saves: saves,
                      reports: reports,
                      likedPeople: likedPeople)
        return NFT
    }
    
    func makePlan() -> Plan {
        let planID = self.get("planID") as! String
        let title = self.get("title") as! String
        let location = self.get("location") as! String
        let latitude = self.get("latitude") as! Double
        let longitude = self.get("longitude") as! Double
        let boarding = self.get("boarding") as! String
        let landing = self.get("landing") as! String
        let days = self.get("days") as! Int
        let writtenDate = self.get("writtenDate") as! Double
        let scrap = self.get("scrap") as! [String]
        let thumbnail = self.get("thumbnail") as! String
        
        let plan = Plan(planID: planID,
                        title: title,
                        location: location,
                        latitude: latitude,
                        longitude: longitude,
                        boarding: boarding,
                        landing: landing,
                        days: days,
                        writtenDate: writtenDate,
                        scrap: scrap,
                        thumbnail: thumbnail)
        return plan
    }
    
    func makeUser() -> User {
        let userUid = self.get("userUid") as! String
        let url = self.get("url") as! String
        let name = self.get("name") as! String
        let introduce = self.get("introduce") as! String
        let blockedUser = self.get("blockedUser") as! [String]
        let bookMark = self.get("bookMark") as! [String]
        let travelLevel = self.get("travelLevel") as! [Int]
        
        let user = User(userUid: userUid, url: url, name: name, introduce: introduce, blockedUser: blockedUser, bookMark: bookMark, travelLevel: travelLevel)
        return user
    }
    
    func makeComment() -> Comment {
        let commentID = self.get("commentID") as! String
        let authorUid = self.get("authorUid") as! String
        let writtenDate = self.get("writtenDate") as! Double
        let content = self.get("content") as! String
        let likes = self.get("likes") as! Int
        let likedPeople = self.get("likedPeople") as! [String]
        
        let comment = Comment(commentID: commentID, authorUid: authorUid, writtenDate: writtenDate, content: content, likes: likes, likedPeople: likedPeople)
        return comment
    }
}
