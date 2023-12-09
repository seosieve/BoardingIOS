//
//  NFTTicketViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/30.
//

import UIKit

class NFTTicketViewController: UIViewController {

    var image: UIImage?
    var NFTResult = NFT.dummyType
    var isFlipped = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var backgroundFullImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
    }
    
    var backgroundVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    var mainLabel = UILabel().then {
        $0.text = "CARD 등록이 완료되었습니다!"
        $0.font = Pretendard.extraBold(24)
        $0.textColor = Gray.white
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.black, for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(18)
        $0.backgroundColor = Gray.white
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
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
    
    lazy var NFTMainTitleLabel = UILabel().then {
        $0.text = self.NFTResult.title
        $0.font = Pretendard.semiBold(16)
        $0.textColor = Gray.black
    }
    
    lazy var NFTSubTitleLabel = UILabel().then {
        $0.text = self.NFTResult.content
        $0.font = Pretendard.regular(14)
        $0.textColor = Gray.medium
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
        
        //NFTTitleView
        NFTView.addSubview(NFTTitleView)
        NFTTitleView.snp.makeConstraints { make in
            make.bottom.left.centerX.equalToSuperview()
            make.height.equalTo(119)
        }
        
        NFTTitleView.addSubview(NFTMainTitleLabel)
        NFTTitleView.addSubview(NFTSubTitleLabel)
        NFTMainTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
        }
        NFTSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(NFTMainTitleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
        
        NFTTitleView.addSubview(QRDetailView)
        QRDetailView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(88)
        }
        
        QRDetailView.addSubview(QRImageView)
        QRImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.top.equalToSuperview()
            make.width.equalTo(88)
        }
        
        QRDetailView.addSubview(QRDetailStackView)
        QRDetailStackView.snp.makeConstraints { make in
            make.left.equalTo(QRImageView.snp.right).offset(26)
            make.right.equalToSuperview()
            make.centerY.top.equalToSuperview()
        }
        let QRInfo = [String(NFTResult.writtenDate), NFTResult.NFTID, "Standard", NFTResult.authorUid]
        for index in 0..<4 {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let mainLabel = UILabel().then {
                $0.text = TicketInfo.QR[index]
                $0.font = Pretendard.semiBold(13)
                $0.textColor = Gray.black
            }
            let subLabel = UILabel().then {
                $0.text = QRInfo[index]
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.medium
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            mainLabel.snp.makeConstraints { make in
                make.centerY.left.equalToSuperview()
                make.width.equalTo(93)
            }
            subLabel.snp.makeConstraints { make in
                make.centerY.right.equalToSuperview()
                make.left.equalTo(mainLabel.snp.right)
            }
            QRDetailStackView.addArrangedSubview(subview)
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
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(360)
        }
        let NFTInfo = [NFTResult.location, NFTResult.time, NFTResult.weather, NFTResult.category, String(Double(NFTResult.starPoint))]
        for index in 0..<5 {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let mainLabel = UILabel().then {
                $0.text = TicketInfo.NFT[index]
                $0.font = Pretendard.semiBold(15)
                $0.textColor = Gray.white
            }
            let subLabel = UILabel().then {
                $0.text = NFTInfo[index]
                $0.font = Pretendard.regular(17)
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
            for index in 0...4 {
                let star = UIImageView()
                if index < NFTResult.starPoint {
                    star.image = UIImage(named: "Star")
                } else {
                    star.image = UIImage(named: "EmptyStar")
                }
                starStackView.addArrangedSubview(star)
            }
            let starValue = UILabel().then {
                $0.text = NFTInfo.last
                $0.font = Pretendard.regular(17)
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
