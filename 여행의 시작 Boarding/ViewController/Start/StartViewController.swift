//
//  StartViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

class StartViewController: UIViewController {

    let viewModel = StartViewModel()
    let disposeBag = DisposeBag()
    
    var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "FakeTitle")
    }
    
    var subLabel = UILabel().then {
        $0.text = "여행의 시작"
        $0.textColor = Gray.semiLight
        $0.font = Pretendard.medium(17)
    }
    
    var appleStartButton = UIButton().then {
        $0.setTitle("Apple로 시작하기", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.cornerRadius = 12
    }
    
    var appleImageView = UIImageView().then {
        $0.image = UIImage(named: "Apple")
    }
    
    lazy var kakaoStartButton = UIButton().then {
        $0.setTitle("Kakao로 시작하기", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.semiLight.cgColor
    }
    
    var kakaoImageView = UIImageView().then {
        $0.image = UIImage(named: "Kakao")
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.setNavigationBar()
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
//            make.centerX.equalToSuperview().offset(18)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
//        view.addSubview(subLabel)
//        subLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(titleImageView.snp.bottom).offset(3)
//        }
        
        view.addSubview(kakaoStartButton)
        kakaoStartButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(65)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        kakaoStartButton.rounded(axis: .horizontal)
        
        kakaoStartButton.addSubview(kakaoImageView)
        kakaoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(appleStartButton)
        appleStartButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoStartButton.snp.top).offset(-14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        appleStartButton.rounded(axis: .horizontal)
        
        appleStartButton.addSubview(appleImageView)
        appleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        //Apple
        appleStartButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.indicator.startAnimating()
                self?.viewModel.appleLogIn()
                self?.appleStartButton.isEnabled = false
                self?.kakaoStartButton.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        //Kakao
        kakaoStartButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.indicator.startAnimating()
                self?.viewModel.kakaoLogIn()
                self?.appleStartButton.isEnabled = false
                self?.kakaoStartButton.isEnabled = false
            })
            .disposed(by: disposeBag)
        
        //공통
        viewModel.errorCatch
            .subscribe(onNext:{ [weak self] error in
                self?.appleStartButton.isEnabled = true
                self?.kakaoStartButton.isEnabled = true
                if error {
                    self?.indicator.stopAnimating()
                    self?.errorAlert()
                } else {
                    self?.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.startResult
            .subscribe(onNext:{ [weak self] result in
                self?.appleStartButton.isEnabled = true
                self?.kakaoStartButton.isEnabled = true
                if result {
                    self?.indicator.stopAnimating()
                    self?.presentVC(TabBarViewController(), transition: .crossDissolve)
                } else {
                    self?.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.userNotExist
            .subscribe(onNext:{ [weak self] in
                //Onboarding으로 넘어가기
                print("User not Exist")
            })
            .disposed(by: disposeBag)
    }
}
