//
//  Names.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 7/30/24.
//

import Foundation

enum Names {
    enum LoginType {
        case apple
        case kakao
    }
    
    enum Preference: CaseIterable {
        case editProfile
        case blockedUsers
        case termsOfUse
        case privatePolicy
        case versionInfo
        case logOut
        case withdraw
        
        ///TableView Titles
        var title: String {
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
    
    enum PreferenceAlert {
        case logOut
        case withdraw
        
        var title: String {
            switch self {
            case .logOut:
                return "정말 로그아웃 하시겠어요?"
            case .withdraw:
                return "정말 회원탈퇴 하시겠어요?"
            }
        }
        
        var message: String {
            switch self {
            case .logOut:
                return "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!"
            case .withdraw:
                return "아쉽지만 다음에 기회가 된다면 다시 Boarding을 찾아주세요!"
            }
        }
        
        var actionTitle: String {
            switch self {
            case .logOut:
                return "로그아웃"
            case .withdraw:
                return "회원탈퇴"
            }
        }
    }
}
