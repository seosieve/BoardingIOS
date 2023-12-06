//
//  UserModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/30.
//

import Foundation

struct User {
    static let defaultUrl = URL(string: "https://t3.ftcdn.net/jpg/00/64/67/52/360_F_64675209_7ve2XQANuzuHjMZXP3aIYIpsDKEbF5dD.jpg")!
    
    let userUid: String
    let url: String
    let name: String
    let introduce: String
    let blockedUser: [String]
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["userUid": userUid,
                "url": url,
                "name": name,
                "introduce": introduce,
                "blockedUser": blockedUser]
    }
    
    // Dummy User
    static var dummyType: User {
        return User(userUid: "",
                    url: "",
                    name: "",
                    introduce: "",
                    blockedUser: [])
    }
}
