//
//  ExtensionModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit

//MARK: - SafeArea Detect
var window: UIWindow {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first ?? UIWindow()
    return window
}

//MARK: - Round View
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

//MARK: - Navigation BackButton Custom
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

//MARK: - StatusBar Style Changable NavigationController
class ChangableNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? { return visibleViewController}
}

//MARK: - Keyboard Dismiss
extension UIViewController {
    func dismissKeyboardWhenTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func presentVC(_ vc: UIViewController) {
        let viewController = vc
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .crossDissolve
        present(viewController, animated: true, completion: nil)
    }
}

//MARK: - BackgroundColorForButtonState
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
