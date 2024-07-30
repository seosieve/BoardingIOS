//
//  NFTDetailViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/06.
//

import UIKit
import RxSwift
import RxCocoa

class NFTDetailViewController: UIViewController {
    
    var url = URL(string: "")
    var NFTResult = NFT.dummyType
    var isFlipped = false
    
    let viewModel = NFTDetailViewModel()
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var viewMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "ViewMore")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.white
        $0.menu = UIMenu(options: .displayInline, children: [UIAction(title: "삭제하기") { _ in
            self.deleteAlert("CARD") {
                self.indicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.viewModel.delete(NFTID: self.NFTResult.NFTID, category: self.NFTResult.category)
            }
        }])
        $0.showsMenuAsPrimaryAction = true
    }
    
    lazy var fullScreenImageView = UIImageView().then {
        $0.sd_setImage(with: url)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    var fullScreenVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    var NFTStatusView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var rewardLabel = UILabel().then {
        $0.text = "획득한 리워드"
        $0.font = Pretendard.semiBold(20)
        $0.textColor = Gray.medium
    }
    
    lazy var MILELabel = UILabel().then {
        $0.text = "\(NFTResult.likes * 100 + NFTResult.saves * 20 - NFTResult.reports * 7) MILE"
        $0.font = Pretendard.semiBold(16)
        $0.textColor = Gray.medium
        let attributedString = NSMutableAttributedString(string: $0.text!)
        attributedString.addAttribute(.font, value: Pretendard.regular(16), range: ($0.text! as NSString).range(of: "MILE"))
        $0.attributedText = attributedString
    }
    
    var NFTStatusStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
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
        $0.sd_setImage(with: URL(string: NFTResult.url))
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
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(flipNFT))
        NFTView.addGestureRecognizer(tap)
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(fullScreenImageView)
        fullScreenImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        fullScreenImageView.addSubview(fullScreenVisualEffectView)
        fullScreenVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(viewMoreButton)
        viewMoreButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-24)
            make.width.height.equalTo(28)
        }
        
        view.addSubview(NFTStatusView)
        NFTStatusView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(160)
            make.bottom.equalToSuperview()
        }
        
        NFTStatusView.addSubview(rewardLabel)
        NFTStatusView.addSubview(MILELabel)
        rewardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.equalToSuperview().offset(26)
        }
        MILELabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.right.equalToSuperview().offset(-26)
        }
        
        let rewardDivider = divider()
        NFTStatusView.addSubview(rewardDivider)
        rewardDivider.snp.makeConstraints { make in
            make.top.equalTo(rewardLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(26)
            make.height.equalTo(1)
        }
        
        NFTStatusView.addSubview(NFTStatusStackView)
        NFTStatusStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(75)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        let icon = [InteractionInfo.like, InteractionInfo.comment, InteractionInfo.report, InteractionInfo.save]
        let count = [NFTResult.likes, NFTResult.comments, NFTResult.reports, NFTResult.saves]
        for index in 0..<icon.count {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let statusImageView = UIImageView().then {
                $0.image = icon[index].0
            }
            let statusLabel = UILabel().then {
                $0.text = String(count[index])
                $0.font = Pretendard.regular(16)
                $0.textColor = Gray.medium
            }
            let divider = UIView().then {
                $0.backgroundColor = Gray.bright
            }
            if index == 3 {
                divider.alpha = 0
            }
            subview.addSubview(statusImageView)
            subview.addSubview(statusLabel)
            subview.addSubview(divider)
            statusImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(5)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(26)
            }
            statusLabel.snp.makeConstraints { make in
                make.top.equalTo(statusImageView.snp.bottom).offset(2)
                make.centerX.equalToSuperview()
            }
            divider.snp.makeConstraints { make in
                make.top.right.centerY.equalToSuperview()
                make.width.equalTo(1)
            }
            NFTStatusStackView.addArrangedSubview(subview)
        }
        
        view.addSubview(NFTView)
        NFTView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
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
        for index in 0..<TicketInfo.NFT.count {
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
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
    
    func setRx() {
        viewModel.processCompleted
            .subscribe(onNext:{ [weak self] in
                self?.indicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
