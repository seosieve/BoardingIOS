//
//  NFTModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/07.
//

import Foundation

struct NFT {
    let NFTID: String
    let authorUid: String
    let writtenDate: Double
    let type: String
    let url: String
    let videoUrl: String
    let location: String
    let country: String
    let city: String
    let latitude: Double
    let longitude: Double
    let time: String
    let weather: String
    let title: String
    let content: String
    let starPoint: Int
    let category: String
    let comments: Int
    let likes: Int
    let saves: Int
    let reports: Int
    let likedPeople: [String]
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["NFTID": NFTID,
                "authorUid": authorUid,
                "writtenDate": writtenDate,
                "type": type,
                "url": url,
                "videoUrl": videoUrl,
                "location": location,
                "country": country,
                "city": city,
                "latitude": latitude,
                "longitude": longitude,
                "time": time,
                "weather": weather,
                "title": title,
                "content": content,
                "starPoint": starPoint,
                "category": category,
                "comments": comments,
                "likes": likes,
                "saves": saves,
                "reports": reports,
                "likedPeople": likedPeople]
    }
    
    // Loading 전 등에 사용될 dummy NFT
    static var dummyType: NFT {
        return NFT(NFTID: "",
                   authorUid: "",
                   writtenDate: 0.0,
                   type: "",
                   url: "",
                   videoUrl: "",
                   location: "",
                   country: "",
                   city: "",
                   latitude: 0.0,
                   longitude: 0.0,
                   time: "",
                   weather: "",
                   title: "",
                   content: "",
                   starPoint: 0,
                   category: "",
                   comments: 0,
                   likes: 0,
                   saves: 0,
                   reports: 0,
                   likedPeople: [])
    }
}
