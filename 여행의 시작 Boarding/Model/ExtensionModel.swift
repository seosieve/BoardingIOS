//
//  ExtensionModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/03.
//

import UIKit
import CryptoKit

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
    
    func errorAlert() {
        let alert = UIAlertController(title: "예상치 못한 에러가 발생했어요", message: "앱을 종료 후 다시 한 번 시도해주세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        alert.addAction(confirm)
        confirm.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
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

//MARK: - Apple LogIn Token
extension NSObject {
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Nonce 생성 오류: \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}
