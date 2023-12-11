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
    
    func rounded(axis: Axis, mask: Bool = true) {
        layoutIfNeeded()
        let value = axis == .horizontal ? self.frame.height/2 : self.frame.width/2
        self.layer.cornerRadius = value
        self.layer.masksToBounds = mask
    }
    
    //Round ShapeLayer
    func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        layoutIfNeeded()
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
        
        let border = CAShapeLayer()
        border.path = maskPath.cgPath
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = UIColor.white.cgColor
        border.lineWidth = 3
        layer.addSublayer(border)
    }
    
    func makeModalCircular() {
        self.clipsToBounds = false
        self.layer.cornerRadius = 28
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func makeShadow(width: Int = 0, height: Int = 0, opacity: Float = 0.5, shadowRadius: Int = 2) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowRadius = CGFloat(shadowRadius)
    }
    
    func makeDashLine() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = Gray.light.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [4,4]
        
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: self.frame.height)
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    func loadingAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.backgroundColor = Gray.white
        })
    }
    
    func touchAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
}

//MARK: - StringStoredView
class StringStoredView: UIView {
    var storedString: String = ""
}

//MARK: - BezierPath Make Ticket Shape
extension UIBezierPath {
    convenience init(shouldRoundRect rect: CGRect, topLeftRadius: CGSize = .zero, topRightRadius: CGSize = .zero, bottomLeftRadius: CGSize = .zero, bottomRightRadius: CGSize = .zero){

        self.init()

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero{
            path.move(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: CGPoint(x: topLeft.x+15.0, y: topLeft.y))
        }

        if topRightRadius != .zero{
            path.addLine(to: CGPoint(x: topRight.x-topRightRadius.width, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height), control1: CGPoint(x: topRight.x, y: topRight.y), control2:CGPoint(x: topRight.x, y: topRight.y+topRightRadius.height))
        } else {
            path.addLine(to: CGPoint(x: topRight.x-15.0, y: topRight.y))
            path.addCurve(to:  CGPoint(x: topRight.x, y: topRight.y+15.0), control1: CGPoint(x: topRight.x-15.0, y: topRight.y+15.0), control2:CGPoint(x: topRight.x, y: topRight.y+15.0))
        }

        if bottomRightRadius != .zero{
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y), control1: CGPoint(x: bottomRight.x, y: bottomRight.y), control2: CGPoint(x: bottomRight.x-bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y-15.0))
            path.addCurve(to: CGPoint(x: bottomRight.x-15.0, y: bottomRight.y), control1: CGPoint(x: bottomRight.x-15.0, y: bottomRight.y-15.0), control2: CGPoint(x: bottomRight.x-15.0, y: bottomRight.y))
        }

        if bottomLeftRadius != .zero{
            path.addLine(to: CGPoint(x: bottomLeft.x+bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height), control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-bottomLeftRadius.height))
        } else {
            path.addLine(to: CGPoint(x: bottomLeft.x+15.0, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y-15.0), control1: CGPoint(x: bottomLeft.x+15.0, y: bottomLeft.y-15.0), control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y-15.0))
        }

        if topLeftRadius != .zero{
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y) , control1: CGPoint(x: topLeft.x, y: topLeft.y) , control2: CGPoint(x: topLeft.x+topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y+15.0))
            path.addCurve(to: CGPoint(x: topLeft.x+15.0, y: topLeft.y) , control1: CGPoint(x: topLeft.x+15.0, y: topLeft.y+15.0) , control2: CGPoint(x: topLeft.x+15.0, y: topLeft.y))
        }

        path.closeSubpath()
        cgPath = path
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
    override var childForStatusBarStyle: UIViewController? { return visibleViewController }
}

//MARK: - unmodifiable UITextField
class immovableTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
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
    
    func presentVC(_ vc: UIViewController, transition: UIModalTransitionStyle) {
        let viewController = vc
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = transition
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
    
    func deleteAlert(_ content: String, _ alertHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "정말로 삭제하시겠어요?", message: "한 번 삭제한 \(content)은 되돌릴 수 없어요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "삭제", style: .default) { action in
            alertHandler()
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(Boarding.red, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
    
    func toastAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let attributes = [NSAttributedString.Key.foregroundColor : Gray.semiDark, NSAttributedString.Key.font : Pretendard.semiBold(19)]
        alert.setValue(NSAttributedString(string: "이미 플랜에 추가되었어요.", attributes: attributes), forKey: "attributedTitle")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Gray.white
        
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func divider() -> UIView {
        return UIView().then {
            $0.backgroundColor = Gray.light.withAlphaComponent(0.4)
        }
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

//MARK: - UILabelLineSpacing
extension UILabel {
    func withLineSpacing(_ lineSpacing: CGFloat) {
        let attString = NSMutableAttributedString(string: self.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        attString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attString.length))
        self.attributedText = attString
    }
    
    func withMultipleFont(_ font: UIFont, range: String) {
        let attributedString = NSMutableAttributedString(string: self.text!)
        attributedString.addAttribute(.font, value: font, range: (self.text! as NSString).range(of: range))
        self.attributedText = attributedString
    }
}

//MARK: - RemoveAllArrangedSubviews
extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

//MARK: - make Dday
func stringToDate(_ string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "yyyy. MM. dd"
    return dateFormatter.date(from: string)!
}

func dateToString(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.timeZone = TimeZone(abbreviation: "KST")
    dateFormatter.dateFormat = "yyyy. MM. dd"
    return dateFormatter.string(from: date)
}

func makeDday(boardingDate: String) -> String {
    let boardingDate = stringToDate(boardingDate)
    let distance = Calendar.current.dateComponents([.day], from: boardingDate, to: Date()).day!
    if distance <= 0 {
        return "D\(distance)"
    } else {
        return "D+\(distance)"
    }
}
