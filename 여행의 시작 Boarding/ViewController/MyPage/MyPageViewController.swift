//
//  MyPageViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MyPageViewController: UIViewController {
    
    let viewModel = MyPageViewModel()
    let disposeBag = DisposeBag()
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(named: "Setting"), for: .normal)
        $0.addTarget(self, action: #selector(settingButtonPressed), for: .touchUpInside)
    }
    
    @objc func settingButtonPressed() {
        let vc = PreferenceViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var userThumbnailView = UIImageView().then {
        $0.image = UIImage(named: "User")
    }
    
    var userNameLabel = UILabel().then {
        $0.text = "박정현"
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
            make.top.equalTo(userAchievementStackView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    func putUserAchievement() {
        let userAchieveItem1 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🇰🇷 Lv.5"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        let userAchieveItem2 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "📷 Lv.7"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        let userAchieveItem3 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🏄‍♂️ Lv.5"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        userAchievementStackView.addArrangedSubview(userAchieveItem1)
        userAchievementStackView.addArrangedSubview(userAchieveItem2)
        userAchievementStackView.addArrangedSubview(userAchieveItem3)
    }
    
    func setRx() {
        viewModel.thumbnail
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
        
        viewModel.aa()
    }
}
