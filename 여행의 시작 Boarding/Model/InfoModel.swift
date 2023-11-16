//
//  InfoModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/23.
//

import UIKit

struct CategoryInfo {
    static let count = name.count
    static let name = ["관광", "휴양", "액티비티", "사진", "맛집", "숙소", "교통", "쇼핑", "축제"]
    static let imoji = ["🗽", "🏖️", "🏄🏻", "📸", "🍔", "🏡", "🚃", "🛍️", "🎉"]
}

struct PhotoInfo {
    static let icon = [UIImage(named: "Location"), UIImage(named: "Time"), UIImage(named: "Weather")]
}

struct InteractionInfo {
    static let like = (UIImage(named: "Like")!, UIImage(named: "LikeFilled")!)
    static let comment = (UIImage(named: "Comment")!, UIImage())
    static let report = (UIImage(named: "Report")!, UIImage())
    static let save = (UIImage(named: "Save")!, UIImage(named: "SaveFilled")!)
}

struct TicketInfo {
    static let NFT = ["위치", "시간", "날씨", "카테고리", "평점"]
    static let QR = ["Contract Ad.", "Token ID", "Standard", "Chain"]
}

