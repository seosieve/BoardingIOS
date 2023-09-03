//
//  NFTViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/30.
//

import UIKit
import Then
import SnapKit

class NFTViewController: UIViewController {

    var image: UIImage?
    var isFlipped = false
    let NFTTitle = ["위치", "시간", "날씨", "카테고리", "평점"]
    let NFTInfo = ["finns, 덴파사르", "2023.06.05.  12:30PM", "맑음, 30°C", "맛집", "5.0"]
    let QRTitle = ["Contract Address", "Token ID", "Token Standard", "Chain"]
    let QRInfo = ["FINNS", "13DE79TA23", "Standard", "76$A@*YSD"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var backgroundFullImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    var backgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var mainLabel = UILabel().then {
        $0.text = "NFT 등록이 완료되었습니다!"
        $0.font = Pretendard.extraBold(24)
        $0.textColor = Gray.white
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(18)
        $0.backgroundColor = Boarding.blue
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        FirebaseStorageManager.uploadImage(image: image!, pathRoot: "aa") { url in
            if let url = url {
                UserDefaults.standard.set(url.absoluteString, forKey: "myImageUrl")
                self.title = "이미지 업로드 완료"
            }
        }
        
        
        let vc = TabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    var NFTView = UIView()
    
    @objc func flipNFT() {
        UIView.transition(with: self.NFTView, duration: 2, options: .transitionFlipFromLeft, animations: nil)
        changeContents()
    }
    
    var NFTTitleView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var NFTMainTitleLabel = UILabel().then {
        $0.text = "혁명 기념일 불꽃놀이"
        $0.font = Pretendard.semiBold(16)
        $0.textColor = Gray.black
    }
    
    var NFTSubTitleLabel = UILabel().then {
        $0.text = "프랑스 혁명 기념일에 매년 전통 불꽃 놀이가 프랑스 수도에서 가장 상징적인 건축물, 에펠탑을 중심으로 독특한 볼거리를 연출한다."
        $0.font = Pretendard.regular(14)
        $0.textColor = UIColor("#8C8C8C")
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var NFTImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    var NFTvisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    var NFTDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
        $0.alpha = 0
    }
    
    var QRDetailView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.alpha = 0
    }
    
    var QRDetailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
    }
    
    var QRImageView = UIImageView().then {
        $0.image = UIImage(named: "QRCode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Gray.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(flipNFT))
        NFTView.addGestureRecognizer(tap)
        setViews()
    }
    
    func setViews() {
        view.addSubview(backgroundFullImageView)
        view.addSubview(backgroundVisualEffectView)
        backgroundFullImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(99)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
        
        view.addSubview(NFTView)
        NFTView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(32)
            make.bottom.equalTo(completeButton.snp.top).offset(-61)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        NFTView.layer.shadowOffset = CGSize(width:2, height:2)
        NFTView.layer.shadowRadius = 6
        NFTView.layer.shadowColor = UIColor.black.cgColor
        NFTView.layer.shadowOpacity = 0.3
        
        //NFTTitleView
        NFTView.addSubview(NFTTitleView)
        NFTTitleView.snp.makeConstraints { make in
            make.bottom.left.centerX.equalToSuperview()
            make.height.equalTo(119)
        }
        
        NFTTitleView.addSubview(NFTMainTitleLabel)
        NFTTitleView.addSubview(NFTSubTitleLabel)
        NFTMainTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(21)
            make.top.equalToSuperview().offset(18)
        }
        NFTSubTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(21)
            make.top.equalTo(NFTMainTitleLabel.snp.bottom).offset(6)
        }
        NFTTitleView.addSubview(QRDetailView)
        QRDetailView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(21)
            make.height.equalTo(97)
        }
        QRDetailView.addSubview(QRDetailStackView)
        QRDetailStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.centerY.top.equalToSuperview()
            make.width.equalTo(180)
        }
        for index in 0...3 {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let mainLabel = UILabel().then {
                $0.text = QRTitle[index]
                $0.font = Pretendard.regular(14)
                $0.textColor = Gray.dark
            }
            let subLabel = UILabel().then {
                $0.text = QRInfo[index]
                $0.font = Pretendard.light(14)
                $0.textColor = Gray.dark
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            mainLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview()
            }
            subLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview()
            }
            QRDetailStackView.addArrangedSubview(subview)
        }
        
        QRDetailView.addSubview(QRImageView)
        QRImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.top.equalToSuperview()
            make.width.equalTo(93)
        }
        NFTTitleView.roundCorners(bottomLeft: 20, bottomRight: 20)
        
        //NFTImageView
        NFTView.addSubview(NFTImageView)
        NFTImageView.snp.makeConstraints { make in
            make.top.left.centerX.equalToSuperview()
            make.bottom.equalTo(NFTTitleView.snp.top)
        }
        
        NFTImageView.addSubview(NFTvisualEffectView)
        NFTvisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        NFTvisualEffectView.alpha = 0
        
        NFTImageView.addSubview(NFTDetailStackView)
        NFTDetailStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(24)
            make.height.equalTo(360)
        }
        for index in 0...4 {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let mainLabel = UILabel().then {
                $0.text = NFTTitle[index]
                $0.font = Pretendard.semiBold(16)
                $0.textColor = Gray.white
            }
            let subLabel = UILabel().then {
                $0.text = NFTInfo[index]
                $0.font = Pretendard.light(16)
                $0.textColor = Gray.white
            }
            let divider = UIView().then {
                $0.backgroundColor = Gray.white.withAlphaComponent(0.5)
            }
            let starStackView = UIStackView().then {
                $0.axis = .horizontal
                $0.distribution = .fillEqually
                $0.spacing = 2
                $0.alpha = 0
            }
            for _ in 0...4 {
                let star = UIImageView().then {
                    $0.image = UIImage(named: "Star")
                }
                starStackView.addArrangedSubview(star)
            }
            let starValue = UILabel().then {
                $0.text = NFTInfo.last
                $0.font = Pretendard.regular(14)
                $0.textColor = Gray.white
                $0.alpha = 0
            }
            if index == 4 {
                divider.alpha = 0
                subLabel.alpha = 0
                starStackView.alpha = 1
                starValue.alpha = 1
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            subview.addSubview(divider)
            subview.addSubview(starStackView)
            subview.addSubview(starValue)
            mainLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(12)
                make.left.equalToSuperview().inset(20)
            }
            subLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(12)
                make.left.equalToSuperview().inset(20)
            }
            divider.snp.makeConstraints { make in
                make.bottom.left.centerX.equalToSuperview()
                make.height.equalTo(0.5)
            }
            starStackView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(12)
                make.left.equalToSuperview().inset(20)
                make.height.equalTo(18)
                make.width.equalTo(104)
            }
            starValue.snp.makeConstraints { make in
                make.centerY.equalTo(starStackView)
                make.left.equalTo(starStackView.snp.right).offset(7)
            }
            NFTDetailStackView.addArrangedSubview(subview)
        }
        NFTImageView.roundCorners(topLeft: 20, topRight: 20)
    }
    
    func changeContents() {
        if isFlipped {
            NFTvisualEffectView.alpha = 0
            NFTDetailStackView.alpha = 0
            QRDetailView.alpha = 0
        } else {
            NFTvisualEffectView.alpha = 1
            NFTDetailStackView.alpha = 1
            QRDetailView.alpha = 1
        }
        isFlipped.toggle()
    }
}

//MARK: - BezierPath
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

//MARK: - UIView
extension UIView{
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
}
