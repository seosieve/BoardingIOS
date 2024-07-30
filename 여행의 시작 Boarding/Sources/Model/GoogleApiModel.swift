//
//  GoogleApiModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/07.
//

import Foundation

//MARK: - Geocode API Model
struct Geo: Codable {
    var results: [Results]
}

struct Results: Codable {
    var formatted_address: String
    var place_id: String
}

//MARK: - Places API Model
struct Place: Codable {
    var result: Result
}

struct Result: Codable {
    var editorial_summary: editorialSummary?
    var name: String
    var reviews: [review]?
    var vicinity: String
}

struct editorialSummary: Codable {
    var overview: String
}

struct review: Codable {
    var text: String
}
