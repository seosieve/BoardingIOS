//
//  LocationModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/22.
//

import Foundation

struct Location {
    var url: String
    let country: String
    let city: String
    var count: Int
    
    static var dummyType: Location {
        return Location(url: "",
                        country: "",
                        city: "",
                        count: 0
        )
    }
}
