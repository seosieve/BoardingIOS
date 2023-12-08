//
//  LocationModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/22.
//

import Foundation

struct Location {
    static let global =  "https://global.cornell.edu/sites/default/files/styles/homepage_banner/public/2021-08/AdobeStock_283024784_f.jpg?h=df51affa&itok=1GAXdnae"
    
    let url: String
    let country: String
    let city: String
    let count: Int
    
    static var dummyType: Location {
        return Location(url: "",
                        country: "",
                        city: "",
                        count: 0)
    }
}
