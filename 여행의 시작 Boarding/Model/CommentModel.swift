//
//  CommentModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/14/23.
//

import Foundation

struct Comment {
    let commentID: String
    let authorUid: String
    let writtenDate: Double
    let content: String
    let likes: Int
    let likedPeople: [String]
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["commentID": commentID,
                "authorUid": authorUid,
                "writtenDate": writtenDate,
                "content": content,
                "likes": likes,
                "likedPeople": likedPeople]
    }
    
    // Dummy Report
    static var dummyType: Comment {
        return Comment(commentID: "",
                       authorUid: "",
                       writtenDate: 0.0,
                       content: "",
                       likes: 0,
                       likedPeople: [])
    }
}
