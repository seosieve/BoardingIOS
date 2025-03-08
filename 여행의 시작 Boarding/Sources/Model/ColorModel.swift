//
//  ColorModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit

struct Boarding {
    static let blue = UIColor("#107CFA")
    static let lightBlue = UIColor("#E8F2FF")
    static let skyBlue = UIColor("#44D0FA")
    static let red = UIColor("#F9207B")
    static let lightRed = UIColor("#FED2E5")
}

struct Gray {
    static let black = UIColor("#222222")
    static let semiDark = UIColor("#575B63")
    static let dark = UIColor("#777777")
    static let medium = UIColor("#919396")
    static let light = UIColor("#BCBCBC")
    static let semiLight = UIColor("#D3D4D5")
    static let bright = UIColor("#EEEEEE")
    static let white = UIColor("#FFFFFF")
}

//MARK: - UIColor with Hex
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
    func gradient(_ colors: [UIColor], axis: Axis = .horizontal) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map{ $0.cgColor }

        switch axis {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        }
        
        self.layer.addSublayer(gradientLayer)
    }
    
    func gradientBorder() {
        let lineWidth: CGFloat = 2
        let rect = self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradientLayer.colors = [Boarding.skyBlue, Boarding.blue].map{ $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: rect, cornerRadius: self.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = shape
        
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.path = UIBezierPath(roundedRect: self.layer.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        backgroundLayer.fillColor = Boarding.lightBlue.cgColor

        self.layer.addSublayer(backgroundLayer)
        self.layer.addSublayer(gradientLayer)
    }
}
