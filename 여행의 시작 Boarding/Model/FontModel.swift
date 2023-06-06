//
//  FontModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit

enum Pretendard: String {
    case Black = "Pretendard-Black"
    case ExtraBold = "Pretendard-ExtraBold"
    case Bold = "Pretendard-Bold"
    case SemiBold = "Pretendard-SemiBold"
    case Medium = "Pretendard-Medium"
    case Regular = "Pretendard-Regular"
    case Light = "Pretendard-Light"
    case ExtraLight = "Pretendard-ExtraLight"
    case Thin = "Pretendard-Thin"
    
    func of(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
    static func black(_ size: CGFloat) -> UIFont {
        return Pretendard.Black.of(size)
    }
    static func extraBold(_ size: CGFloat) -> UIFont {
        return Pretendard.ExtraBold.of(size)
    }
    static func bold(_ size: CGFloat) -> UIFont {
        return Pretendard.Bold.of(size)
    }
    static func semiBold(_ size: CGFloat) -> UIFont {
        return Pretendard.SemiBold.of(size)
    }
    static func medium(_ size: CGFloat) -> UIFont {
        return Pretendard.Medium.of(size)
    }
    static func regular(_ size: CGFloat) -> UIFont {
        return Pretendard.Regular.of(size)
    }
    static func light(_ size: CGFloat) -> UIFont {
        return Pretendard.Light.of(size)
    }
    static func extraLight(_ size: CGFloat) -> UIFont {
        return Pretendard.ExtraLight.of(size)
    }
    static func thin(_ size: CGFloat) -> UIFont {
        return Pretendard.Thin.of(size)
    }
}
