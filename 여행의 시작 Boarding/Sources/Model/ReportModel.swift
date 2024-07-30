//
//  ReportModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/04.
//

import Foundation

struct Report {
    let reportID: String
    let userUid: String
    let NFTID: String
    let authorUid: String
    let writtenDate: String
    let reason: String
    let detail: String
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["reportID": reportID,
                "userUid": userUid,
                "NFTID": NFTID,
                "authorUid": authorUid,
                "writtenDate": writtenDate,
                "reason": reason,
                "detail": detail]
    }
    
    // Dummy Report
    static var dummyType: Report {
        return Report(reportID: "",
                      userUid: "",
                      NFTID: "",
                      authorUid: "",
                      writtenDate: "",
                      reason: "",
                      detail: "")
    }
}
