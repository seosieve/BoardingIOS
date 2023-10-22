//
//  NFTModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/07.
//

import Foundation

struct NFT {
    let NFTID: String
    let autherUid: String
    let writtenDate: Double
    let type: String
    let url: String
    let location: String
    let time: String
    let weather: String
    let title: String
    let content: String
    let starPoint: Int
    let category: [String]
    let comments: Int
    let likes: Int
    let saves: Int
    let reports: Int
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["NFTID": NFTID,
                "autherUid": autherUid,
                "writtenDate": writtenDate,
                "type": type,
                "url": url,
                "location": location,
                "time": time,
                "weather": weather,
                "title": title,
                "content": content,
                "starPoint": starPoint,
                "category": category,
                "comments": comments,
                "likes": likes,
                "saves": saves,
                "reports": reports
        ]
    }
    
    // Loading 전 등에 사용될 dummy NFT
    static var dummyType: NFT {
        return NFT(NFTID: "",
                   autherUid: "",
                   writtenDate: 0.0,
                   type: "",
                   url: "",
                   location: "",
                   time: "",
                   weather: "",
                   title: "",
                   content: "",
                   starPoint: 0,
                   category: [String](),
                   comments: 0,
                   likes: 0,
                   saves: 0,
                   reports: 0
        )
    }
}
