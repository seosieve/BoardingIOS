//
//  NFTModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/07.
//

import Foundation

struct NFT {
    let NFTID: String
    let auther: String
    let autherEmail: String
    let type: String
    let url: String
    let location: String
    let time: String
    let weather: String
    let temperature: String
    let title: String
    let mainText: String
    let starPoint: Int
    let category: String
    let comments: Int
    let likes: Int
    let saves: Int
    let reports: Int
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["NFTID": NFTID,
                "auther": auther,
                "autherEmail": autherEmail,
                "type": type,
                "url": url,
                "location": location,
                "time": time,
                "weather": weather,
                "temperature": temperature,
                "title": title,
                "mainText": mainText,
                "starPoint": starPoint,
                "category": category,
                "comments": comments,
                "likes": likes,
                "saves": saves,
                "reports": reports
        ]
    }
}
