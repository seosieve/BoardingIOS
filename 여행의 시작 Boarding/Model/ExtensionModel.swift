//
//  ExtensionModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit

//MARK: - safeArea Detect
var window: UIWindow {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first ?? UIWindow()
    return window
}

//MARK: - round View
extension UIView {
    enum Axis {
        case horizontal, vertical
    }
    
    func rounded(axis: Axis) {
        layoutIfNeeded()
        let value = axis == .horizontal ? self.frame.height/2 : self.frame.width/2
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
    }    
}

extension UINavigationBar {
    func setNavigationBar() {
        self.isHidden = false
        self.topItem?.title = ""
        self.titleTextAttributes = [NSAttributedString.Key.font: Pretendard.semiBold(18)]
        //BackButton Custom
        self.backIndicatorImage = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0))
        self.backIndicatorTransitionMaskImage = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate).withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -14, bottom: 0, right: 0))
        self.tintColor = Gray.black
    }
    
    func bottom() -> CGFloat {
        return self.frame.height + window!.safeAreaInsets.top
    }
}
