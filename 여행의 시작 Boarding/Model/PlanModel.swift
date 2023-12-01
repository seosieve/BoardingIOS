//
//  PlanModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/10.
//

import Foundation

struct Plan {
    let planID: String
    let title: String
    let location: String
    let latitude: Double
    let longitude: Double
    let boarding: String
    let landing: String
    let days: Int
    let writtenDate: Double
    let scrap: [String]
    
    // [String:Any] 타입으로 변환
    var dicType: [String: Any] {
        return ["planID": planID,
                "title": title,
                "location": location,
                "latitude": latitude,
                "longitude": longitude,
                "boarding": boarding,
                "landing": landing,
                "days": days,
                "writtenDate": writtenDate,
                "scrap": scrap
        ]
    }
    
    // Dummy Plan
    static var dummyType: Plan {
        return Plan(planID: "",
                    title: "",
                    location: "",
                    latitude: 0.0,
                    longitude: 0.0,
                    boarding: "",
                    landing: "",
                    days: 0,
                    writtenDate: 0.0,
                    scrap: [String]())
    }
    
    static let placeHolder = ["여행 제목", "여행지", "가는 날", "오는 날"]
}


