//
//  InfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class InfoViewController: UIViewController {

    var byHomeVC = false
    
    var user = User.dummyType
    var url = URL(string: "")
    var NFTResult = NFT.dummyType
    
    lazy var viewModel = InfoViewModel(NFTID: NFTResult.NFTID)
    let disposeBag = DisposeBag()
    
    lazy var buttonWidth = (self.view.frame.width - 40) / 3
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    var headerView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.alpha = 0
    }
    
    var headerDivider = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.alpha = 0
    }
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.white
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var viewMoreButton = UIButton().then {
        $0.setImage(UIImage(named: "ViewMore")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.white
        
        let shareAction = UIAction(title: "공유하기") { _ in
            self.viewModel.shareNFT(NFT: self.NFTResult)
        }
        let deleteAction = UIAction(title: "삭제하기") { _ in
            self.deleteAlert("CARD") {
                self.indicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.viewModel.delete(NFTID: self.NFTResult.NFTID, category: self.NFTResult.category)
            }
        }
        let actionArray = byHomeVC ? [shareAction] : [shareAction, deleteAction]
        $0.menu = UIMenu(options: .displayInline, children: actionArray)
        $0.showsMenuAsPrimaryAction = true
    }
    
    var recordInfoScrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    var recordInfoContentView = UIView()
    
    lazy var headerImageView = UIImageView().then {
        $0.sd_setImage(with: url, placeholderImage: UIImage())
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
    }
    
    var headerVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    lazy var titleLabel = UILabel().then {
        $0.text = NFTResult.title
        $0.textColor = Gray.white
        $0.font = Pretendard.semiBold(25)
    }
    
    lazy var photoView = UIImageView().then {
        $0.sd_setImage(with: url, placeholderImage: UIImage())
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
    }
    
    var contentBackgroundView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    lazy var userImage = UIImageView().then {
        $0.sd_setImage(with: URL(string: user.url), placeholderImage: UIImage())
        $0.tintColor = Boarding.blue
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.text = user.name
        $0.backgroundColor = Gray.white
        $0.font = Pretendard.medium(19)
        $0.textColor = Gray.black
    }
    
    lazy var starValue = UILabel().then {
        $0.text = String(Double(NFTResult.starPoint))
        $0.font = Pretendard.medium(17)
        $0.textColor = Boarding.blue
    }
    
    let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = NFTResult.content
        $0.textColor = Gray.semiDark
        $0.font = Pretendard.regular(17)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.withLineSpacing(4)
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 15
    }
    
    lazy var saveButton = UIButton().then {
        $0.tag = 3
        $0.setImage(InteractionInfo.save.0.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setImage(InteractionInfo.save.1.withRenderingMode(.alwaysTemplate), for: .selected)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(iconButtonPressed(_:)), for: .touchUpInside)
    }
    
    let saveNumberLabel = UILabel().then {
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.dark
        $0.textAlignment = .center
    }
    
    @objc func iconButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            viewModel.likeAction()
            sender.isSelected.toggle()
            sender.touchAnimation()
        case 2:
            if viewModel.userUid == user.userUid { break }
            let vc = ReportViewController()
            vc.authorUid = user.userUid
            vc.NFTID = NFTResult.NFTID
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        default:
            let vc = AddMyPlanViewController()
            vc.NFTID = NFTResult.NFTID
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        }
    }
    
    var myPageButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    lazy var LocationInfoButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("위치", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.semiBold(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(recordInfoButtonPressed), for: .touchUpInside)
        $0.isSelected = true
    }
    
    lazy var UserInfoButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("유저정보", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(recordInfoButtonPressed), for: .touchUpInside)
    }
    
    lazy var NFTInfoButton = UIButton().then {
        $0.tag = 2
        $0.setTitle("CARD", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(recordInfoButtonPressed), for: .touchUpInside)
    }
    
    @objc func recordInfoButtonPressed(sender: UIButton!) {
        pageViewMotion(tag: sender.tag)
        buttonMotion(tag: sender.tag)
    }
    
    var divider = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var selectedDivider = UIView().then {
        $0.backgroundColor = Boarding.blue
    }
    
    var infoPageViewController = InfoPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.bright
        recordInfoScrollView.delegate = self
        infoPageViewController.NFTResult = NFTResult
        infoPageViewController.byHomeVC = byHomeVC
        infoPageViewController.user = user
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(recordInfoScrollView)
        recordInfoScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        recordInfoScrollView.addSubview(recordInfoContentView)
        recordInfoContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.centerX.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top + 50)
        }
        
        view.addSubview(headerDivider)
        headerDivider.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(0.5)
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
        
        recordInfoContentView.addSubview(headerImageView)
        headerImageView.snp.makeConstraints { make in
            make.left.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(-300)
            make.height.equalTo(670)
        }
        
        headerImageView.addSubview(headerVisualEffectView)
        headerVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerImageView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(200)
            make.width.equalTo(150)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        headerImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(photoView.snp.top).offset(-12)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        headerImageView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(photoView)
            make.left.equalTo(photoView.snp.right).offset(12)
            make.height.equalTo(photoView)
            make.right.equalToSuperview().inset(20)
        }
        let info = [NFTResult.location, NFTResult.time, NFTResult.weather]
        for index in 0...2 {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            let iconImageView = UIImageView().then {
                $0.image = PhotoInfo.icon[index]
            }
            let infoLabel = UILabel().then {
                $0.text = info[index]
                $0.textColor = Gray.white
                $0.font = Pretendard.regular(17)
            }
            let infoDivider = divider().then {
                $0.backgroundColor = Gray.white
                if index == 2 { $0.alpha = 0 }
            }
            
            subview.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(4)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
            subview.addSubview(infoLabel)
            infoLabel.snp.makeConstraints { make in
                make.left.equalTo(iconImageView.snp.right).offset(8)
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
            subview.addSubview(infoDivider)
            infoDivider.snp.makeConstraints { make in
                make.top.equalTo(subview.snp.bottom)
                make.centerX.left.equalToSuperview()
                make.height.equalTo(0.5)
            }
            infoStackView.addArrangedSubview(subview)
        }
        
        recordInfoContentView.insertSubview(contentBackgroundView, belowSubview: headerImageView)
        contentBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(headerImageView.snp.bottom).offset(-24)
            make.left.centerX.equalToSuperview()
        }
        
        contentBackgroundView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(52)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(32)
        }
        
        contentBackgroundView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.left.equalTo(userImage.snp.right).offset(4)
        }
        
        contentBackgroundView.addSubview(starValue)
        starValue.snp.makeConstraints { make in
            make.centerY.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(32)
        }
        
        contentBackgroundView.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.centerY.equalTo(starValue)
            make.right.equalTo(starValue.snp.left).offset(-4)
        }
        for index in 0...4 {
            let star = UIImageView().then {
                $0.tintColor = Boarding.blue
            }
            if index < NFTResult.starPoint {
                star.image = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
            } else {
                star.image = UIImage(named: "EmptyStar")?.withRenderingMode(.alwaysTemplate)
            }
            star.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
            starStackView.addArrangedSubview(star)
        }
        
        contentBackgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentBackgroundView.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(48)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        let icon = [InteractionInfo.like, InteractionInfo.report]
        for index in 0..<icon.count {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            
            lazy var iconButton = UIButton().then {
                $0.tag = index+1
                $0.setImage(icon[index].0.withRenderingMode(.alwaysTemplate), for: .normal)
                $0.setImage(icon[index].1.withRenderingMode(.alwaysTemplate), for: .selected)
                $0.tintColor = Gray.dark
                $0.addTarget(self, action: #selector(iconButtonPressed(_:)), for: .touchUpInside)
            }
            
            let numberLabel = UILabel().then {
                $0.tag = index+4
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.dark
                $0.textAlignment = .center
            }
            
            subview.addSubview(iconButton)
            iconButton.snp.makeConstraints { make in
                make.top.left.centerX.equalToSuperview()
                make.width.height.equalTo(30)
            }
            subview.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.top.equalTo(iconButton.snp.bottom)
                make.left.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            interactionStackView.addArrangedSubview(subview)
        }
        
        contentBackgroundView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(interactionStackView)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(30)
        }
        
        contentBackgroundView.addSubview(saveNumberLabel)
        saveNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom)
            make.centerX.equalTo(saveButton)
        }
        
        let recordInfoDivider = divider()
        contentBackgroundView.addSubview(recordInfoDivider)
        recordInfoDivider.snp.makeConstraints { make in
            make.top.equalTo(interactionStackView.snp.bottom).offset(30)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentBackgroundView.addSubview(myPageButtonStackView)
        myPageButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(recordInfoDivider)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        myPageButtonStackView.addArrangedSubview(LocationInfoButton)
        myPageButtonStackView.addArrangedSubview(UserInfoButton)
        myPageButtonStackView.addArrangedSubview(NFTInfoButton)
        
        contentBackgroundView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(myPageButtonStackView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(2)
            make.bottom.equalToSuperview()
        }
        
        contentBackgroundView.addSubview(selectedDivider)
        selectedDivider.snp.makeConstraints { make in
            make.top.equalTo(myPageButtonStackView.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(2)
        }
        
        let height = NFTResult.latitude == 0 && NFTResult.longitude == 0 ? 350 : 430
        addChild(infoPageViewController)
        recordInfoContentView.addSubview(infoPageViewController.view)
        infoPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(contentBackgroundView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.thumbnail
            .subscribe(onNext: { url in
                if !self.byHomeVC {
                    self.userImage.sd_setImage(with: url, placeholderImage: UIImage())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.username
            .subscribe(onNext: { username in
                if !self.byHomeVC {
                    self.userNameLabel.text = username
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.likeCount
            .subscribe(onNext: { count in
                self.interactionStackView.arrangedSubviews
                    .compactMap { $0.viewWithTag(4) as? UILabel }
                    .forEach { $0.text = String(count) }
            })
            .disposed(by: disposeBag)
        
        viewModel.reportCount
            .subscribe(onNext: { count in
                self.interactionStackView.arrangedSubviews
                    .compactMap { $0.viewWithTag(5) as? UILabel }
                    .forEach { $0.text = String(count) }
            })
            .disposed(by: disposeBag)
        
        viewModel.saveCount
            .subscribe(onNext: { count in
                self.saveNumberLabel.text = String(count)
            })
            .disposed(by: disposeBag)
        
        viewModel.likedPeople
            .subscribe(onNext: { likedPeople in
                self.interactionStackView.arrangedSubviews
                    .compactMap { $0.viewWithTag(1) as? UIButton }
                    .forEach { $0.isSelected = likedPeople.contains(self.viewModel.userUid) ? true : false }
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext:{ [weak self] in
                self?.indicator.stopAnimating()
                let vc = self?.navigationController!.viewControllers[0] as! RecordViewController
                self?.navigationController?.popToViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func pageViewMotion(tag: Int) {
        var forward: Bool
        switch tag {
        case 0:
            forward = false
        case 1:
            forward = (LocationInfoButton.isSelected) ? true : false
        default:
            forward = true
        }
        infoPageViewController.moveFromIndex(index: tag, forward: forward)
    }
    
    func buttonMotion(tag: Int) {
        var constraint: CGFloat
        switch tag {
        case 0:
            constraint = 20
        case 1:
            constraint = buttonWidth + 20
        default:
            constraint = buttonWidth * 2 + 20
        }
        
        [LocationInfoButton, UserInfoButton, NFTInfoButton].forEach { button in
            if button.tag == tag {
                button.isSelected = true
                button.titleLabel?.font = Pretendard.semiBold(17)
            } else {
                button.isSelected = false
                button.titleLabel?.font = Pretendard.regular(17)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.selectedDivider.snp.updateConstraints { make in
                make.left.equalToSuperview().offset(constraint)
            }
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UIScrollView
extension InfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.frame.origin.y + scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        headerView.alpha = CGFloat(level/250)
        headerDivider.alpha = CGFloat(level/100)
    }
}
