//
//  MyPageViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    
    lazy var buttonWidth = (self.view.frame.width - 40) / 3
    
    let viewModel = MyPageViewModel()
    let disposeBag = DisposeBag()
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var settingButton = UIButton().then {
        $0.setImage(UIImage(named: "Setting"), for: .normal)
    }
    
    var userThumbnailView = UIImageView().then {
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = Gray.light
    }
    
    var userNameLabel = UILabel().then {
        $0.text = "User Name"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var userAchievementStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    var userCommentLabel = UILabel().then {
        $0.text = "세상의 모든 아름다움을 담아가는 여행자입니다."
        $0.font = Pretendard.regular(14)
        $0.textColor = Gray.black
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    lazy var modalView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 24
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.shadowOffset = CGSize(width:0, height:-3)
        $0.layer.shadowRadius = 10
        $0.layer.shadowColor = Gray.black.cgColor
        $0.layer.shadowOpacity = 0.1
        let pan = UIPanGestureRecognizer(target: self, action: #selector(addModalMotion))
        $0.addGestureRecognizer(pan)
    }
    
    @objc func addModalMotion(_ recognizer: UIPanGestureRecognizer) {
        let minY = window.safeAreaInsets.top
        let maxY = minY + 246
        
        switch recognizer.state {
        case .began, .changed:
            let translation = recognizer.translation(in: modalView)
            let y = min(maxY, max(minY, modalView.frame.minY + translation.y))
            modalView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(y)
            }
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
        case .ended:
            let velocity = recognizer.velocity(in: modalView).y
            let shouldClose = velocity > 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.modalView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(shouldClose ? maxY : minY)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
            //ScrollView, PageView 스크롤 꼬임방지 Relay 설정
            modalPageViewController.pageList.forEach { vc in
                switch vc {
                case is NFTViewController:
                    if let vc = vc as? NFTViewController {
                        vc.modalClosed.accept(shouldClose)
                    }
                case is MILEViewController:
                    if let vc = vc as? MILEViewController {
                        vc.modalClosed.accept(shouldClose)
                    }
                default:
                    if let vc = vc as? ExpertLevelViewController {
                        vc.modalClosed.accept(shouldClose)
                    }
                }
            }
        default:
            break
        }
    }
    
    var myPageButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    lazy var NFTButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("CARD", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.semiBold(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(myPageButtonPressed), for: .touchUpInside)
        $0.isSelected = true
    }
    
    lazy var MILEButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("MILE", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(myPageButtonPressed), for: .touchUpInside)
    }
    
    lazy var ExpertButton = UIButton().then {
        $0.tag = 2
        $0.setTitle("전문가", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.setTitleColor(Boarding.blue, for: .selected)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.contentHorizontalAlignment = .center
        $0.addTarget(self, action: #selector(myPageButtonPressed), for: .touchUpInside)
    }
    
    @objc func myPageButtonPressed(sender: UIButton!) {
        pageViewMotion(tag: sender.tag)
        buttonMotion(tag: sender.tag)
    }

    var divider = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var selectedDivider = UIView().then {
        $0.backgroundColor = Boarding.blue
    }
    
    var modalPageViewController = ModalPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.bright
        setViews()
        putUserAchievement()
        setRx()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.addSubview(settingButton)
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(statusBarView.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(userThumbnailView)
        userThumbnailView.snp.makeConstraints { make in
            make.top.equalTo(statusBarView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(112)
        }
        userThumbnailView.rounded(axis: .horizontal)
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userThumbnailView.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(userAchievementStackView)
        userAchievementStackView.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(24)
        }
        
        view.addSubview(userCommentLabel)
        userCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(userAchievementStackView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(window.safeAreaInsets.top + 246)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(view.frame.height - window.safeAreaInsets.top)
        }
        
        modalView.addSubview(myPageButtonStackView)
        myPageButtonStackView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(55)
        }
        myPageButtonStackView.addArrangedSubview(NFTButton)
        myPageButtonStackView.addArrangedSubview(MILEButton)
        myPageButtonStackView.addArrangedSubview(ExpertButton)
        
        modalView.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(myPageButtonStackView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(2)
        }
        
        modalView.addSubview(selectedDivider)
        selectedDivider.snp.makeConstraints { make in
            make.top.equalTo(myPageButtonStackView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(buttonWidth + 20)
            make.height.equalTo(2)
        }
        
        addChild(modalPageViewController)
        modalView.addSubview(modalPageViewController.view)
        modalPageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(selectedDivider.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(150)
        }
        modalPageViewController.didMove(toParent: self)
    }
    
    func putUserAchievement() {
        let userAchieveItem1 = UILabel().then {
            $0.backgroundColor = Gray.white
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🇰🇷 Lv.1"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        
        let userAchieveItem2 = UILabel().then {
            $0.backgroundColor = Gray.white
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "📷 Lv.1"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        
        let userAchieveItem3 = UILabel().then {
            $0.backgroundColor = Gray.white
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🏄‍♂️ Lv.1"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
            $0.clipsToBounds = true
        }
        
        userAchievementStackView.addArrangedSubview(userAchieveItem1)
        userAchievementStackView.addArrangedSubview(userAchieveItem2)
        userAchievementStackView.addArrangedSubview(userAchieveItem3)
    }
    
    func pageViewMotion(tag: Int) {
        var forward: Bool
        switch tag {
        case 0:
            forward = false
        case 1:
            forward = (NFTButton.isSelected) ? true : false
        default:
            forward = true
        }
        modalPageViewController.moveFromIndex(index: tag, forward: forward)
    }

    
    func buttonMotion(tag: Int) {
        var constraint: (CGFloat, CGFloat)
        switch tag {
        case 0:
            constraint = (0, buttonWidth + 20)
        case 1:
            constraint = (buttonWidth + 20, buttonWidth)
        default:
            constraint = (buttonWidth * 2 + 20, buttonWidth + 20)
        }
        
        [NFTButton, MILEButton, ExpertButton].forEach { button in
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
                make.left.equalToSuperview().offset(constraint.0)
                make.width.equalTo(constraint.1)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setRx() {
        viewModel.thumbnail
            .compactMap {$0}
            .flatMapLatest { URL in
                URLSession.shared.rx.data(request: URLRequest(url: URL))
                    .compactMap {UIImage(data: $0)}
                    .catchAndReturn(nil)
            }
            .bind(to: userThumbnailView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.username
            .bind(to: userNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        settingButton.rx.tap
            .subscribe(onNext: {
                let vc = PreferenceViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
