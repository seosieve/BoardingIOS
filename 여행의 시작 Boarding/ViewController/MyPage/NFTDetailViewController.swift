//
//  NFTDetailViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/06.
//

import UIKit

class NFTDetailViewController: UIViewController {
    
    var image = UIImage(named: "France3")
    var isFlipped = false
    let NFTTitle = ["위치", "시간", "날씨", "카테고리", "평점"]
    let NFTInfo = ["finns, 덴파사르", "2023.06.05.  12:30PM", "맑음, 30°C", "맛집", "5.0"]
    let QRTitle = ["Contract Address", "Token ID", "Token Standard", "Chain"]
    let QRInfo = ["FINNS", "13DE79TA23", "Standard", "76$A@*YSD"]
    
    var rotate = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var backgroundFullImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    var backgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var NFTStatusView = UIView().then {
        $0.backgroundColor = Gray.white
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
        self.navigationController?.navigationBar.setNavigationBar()
        self.navigationController?.navigationBar.tintColor = Gray.white
        view.backgroundColor = .white
        let tap = UITapGestureRecognizer(target: self, action: #selector(flipNFT))
        NFTView.addGestureRecognizer(tap)
        setViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundFullImageView.alpha = 0
        self.navigationController?.navigationBar.isHidden = true
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
        
        view.addSubview(NFTStatusView)
        NFTStatusView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(160)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(NFTView)
        NFTView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom()+20)
            make.bottom.equalTo(NFTStatusView.snp.top).offset(-32)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
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
