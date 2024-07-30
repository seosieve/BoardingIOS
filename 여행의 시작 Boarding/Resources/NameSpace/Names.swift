//
//  Names.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 7/30/24.
//

import Foundation

enum Names {
    enum Preference: CaseIterable {
        case editProfile
        case blockedUsers
        case termsOfUse
        case privatePolicy
        case versionInfo
        case logOut
        case withdraw
        
        ///TableView Titles
        var titles: String {
            switch self {
            case .editProfile:
                return "프로필 편집"
            case .blockedUsers:
                return "차단 유저 목록"
            case .termsOfUse:
                return "이용약관"
            case .privatePolicy:
                return "개인정보 보호 정책"
            case .versionInfo:
                return "버전정보"
            case .logOut:
                return "로그아웃"
            case .withdraw:
                return "회원탈퇴"
            }
        }
    }
}
