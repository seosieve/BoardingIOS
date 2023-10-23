//
//  ColorModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit

struct Boarding {
    static let blue = UIColor("#107CFA")
    static let lightBlue = UIColor("#44D0FA")
    static let red = UIColor("#F9207B")
}

struct Gray {
    static let black = UIColor("#222222")
    static let dark = UIColor("#777777")
    static let medium = UIColor("#919396")
    static let light = UIColor("#BCBCBC")
    static let bright = UIColor("#EEEEEE")
    static let white = UIColor("#FFFFFF")
}

extension UIColor {
    convenience init(_ hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a,r,g,b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a,r,g,b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a,r,g,b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a,r,g,b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

//MARK: - Add Gradation
extension UIView {
    func gradient(_ colors: [UIColor], axis: Axis) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map{ $0.cgColor }
        switch axis {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
