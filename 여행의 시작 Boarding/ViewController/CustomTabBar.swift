//
//  CustomTabBar.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit

@IBDesignable
public final class CustomTabBar: UITabBar {
    
    @objc public var centerButtonActionHandler: () -> () = {}

    @IBInspectable public var tabBarItemColor: UIColor?
    @IBInspectable public var centerButtonColor: UIColor?
    @IBInspectable public var centerButtonHeight: CGFloat = 64.0
    @IBInspectable public var padding: CGFloat = 5.0
    @IBInspectable public var buttonImage: UIImage?
    @IBInspectable public var buttonTitle: String?
    
    @IBInspectable public var tabbarColor: UIColor = UIColor.white
    @IBInspectable public var unselectedItemColor: UIColor = UIColor.gray

    private var shapeLayer: CALayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = tabbarColor.cgColor
        shapeLayer.lineWidth = 0
        
        // Shadow above the bar
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
        self.tintColor = tabBarItemColor
        self.unselectedItemTintColor = unselectedItemColor
        self.setupMiddleButton()
    }
    
    override public func draw(_ rect: CGRect) {
        self.addShape()
    }
        
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
    
    private func createPath() -> CGPath {
        let height: CGFloat = 37.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: -10)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: -10)) // the beginning of the trough
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 35), y: -10), controlPoint2: CGPoint(x: centerWidth - 45, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: -10),
                      controlPoint1: CGPoint(x: centerWidth + 45, y: height), controlPoint2: CGPoint(x: (centerWidth + 35), y: -10))
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: -10))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }
    
    private func setupMiddleButton() {
        let centerButton = UIButton(frame: CGRect(x: (self.bounds.width / 2)-(centerButtonHeight/2), y: -35, width: centerButtonHeight, height: centerButtonHeight))
        
        centerButton.setTitle(buttonTitle, for: .normal)
        centerButton.setImage(buttonImage, for: .normal)
        centerButton.gradient([Boarding.skyBlue, Boarding.blue], axis: .horizontal)
        centerButton.layer.cornerRadius = centerButton.frame.size.width / 2.0
        
        centerButton.imageView?.layer.zPosition = 1
        
        centerButton.tintColor = UIColor.white
        centerButton.clipsToBounds = true
        //add to the tabbar and add click event
        self.addSubview(centerButton)
        centerButton.addTarget(self, action: #selector(self.centerButtonAction), for: .touchUpInside)
    }
    
    // Menu Button Touch Action
     @objc func centerButtonAction(sender: UIButton) {
        self.centerButtonActionHandler()
     }
}

