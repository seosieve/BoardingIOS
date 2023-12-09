//
//  UserInfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class UserInfoViewController: UIViewController {
    
    var byHomeVC = false
    
    var user = User.dummyType
    
    let viewModel = UserInfoViewModel()
    let disposeBag = DisposeBag()

    var userView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    lazy var userImage = UIImageView().then {
        $0.sd_setImage(with: URL(string: user.url), placeholderImage: UIImage())
        $0.backgroundColor = Gray.light
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.text = user.name
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var userCommentLabel = UILabel().then {
        $0.text = "세상의 모든 아름다움을 담아가는 여행자입니다."
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.medium
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        $0.withLineSpacing(6)
    }
    
    var levelView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var countryImage = UIImageView().then {
        $0.image = UIImage(named: "Korea")
        $0.backgroundColor = Gray.light
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.bright.cgColor
    }
    
    var countryLabel = UILabel().then {
        $0.text = "대한민국"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var levelLabel = UILabel().then {
        $0.text = "Lv.5"
        $0.font = Pretendard.medium(17)
        $0.textColor = Gray.medium
    }
    
    var levelContainerView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var levelProgressView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 80, height: 8)
        $0.gradient([Boarding.blue, Boarding.skyBlue], axis: .horizontal)
    }
    
    var expLabel = UILabel().then {
        $0.text = "Lv.5 300exp"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.bright
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(userView)
        userView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
        }
        
        userView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(80)
        }
        userImage.rounded(axis: .horizontal)
        
        userView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImage)
            make.left.equalTo(userImage.snp.right).offset(20)
        }
        
        userView.addSubview(userCommentLabel)
        userCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.left.equalTo(userImage.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
//        view.addSubview(levelView)
//        levelView.snp.makeConstraints { make in
//            make.top.equalTo(userView.snp.bottom).offset(10)
//            make.left.equalToSuperview().offset(20)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(120)
//        }
//        
//        levelView.addSubview(countryImage)
//        countryImage.snp.makeConstraints { make in
//            make.left.equalToSuperview().offset(20)
//            make.centerY.equalToSuperview()
//            make.width.height.equalTo(80)
//        }
//        countryImage.rounded(axis: .horizontal)
//        
//        levelView.addSubview(countryLabel)
//        countryLabel.snp.makeConstraints { make in
//            make.top.equalTo(countryImage)
//            make.left.equalTo(countryImage.snp.right).offset(20)
//        }
//        
//        levelView.addSubview(levelLabel)
//        levelLabel.snp.makeConstraints { make in
//            make.bottom.equalTo(countryLabel)
//            make.left.equalTo(countryLabel.snp.right).offset(8)
//        }
//        
//        levelView.addSubview(levelContainerView)
//        levelContainerView.snp.makeConstraints { make in
//            make.top.equalTo(countryLabel.snp.bottom).offset(12)
//            make.left.equalTo(countryLabel)
//            make.right.equalToSuperview().offset(-20)
//            make.height.equalTo(8)
//        }
//        levelContainerView.rounded(axis: .horizontal)
//        
//        levelContainerView.addSubview(levelProgressView)
//        levelProgressView.snp.makeConstraints { make in
//            make.top.left.equalToSuperview()
//            make.width.equalTo(80)
//            make.height.equalTo(8)
//        }
//        levelProgressView.rounded(axis: .horizontal)
//        
//        levelView.addSubview(expLabel)
//        expLabel.snp.makeConstraints { make in
//            make.left.equalTo(countryImage.snp.right).offset(20)
//            make.top.equalTo(levelProgressView.snp.bottom).offset(6)
//        }
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
    }
}
