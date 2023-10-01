//
//  SignUpViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

class SignUpViewController: UIViewController {

    let viewModel = SignUpViewModel()
    let disposeBag = DisposeBag()
    
    var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "TitleGradient")
    }
    
    var subLabel = UILabel().then {
        $0.text = "여행의 시작"
        $0.textColor = Gray.light
        $0.font = Pretendard.medium(14)
    }
    
    var appleSignUpButton = UIButton().then {
        $0.setTitle("Apple로 시작하기", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.cgColor
        $0.layer.cornerRadius = 12
    }
    
    var appleImageView = UIImageView().then {
        $0.image = UIImage(named: "Apple")
    }
    
    lazy var kakaoSignUpButton = UIButton().then {
        $0.setTitle("Kakao로 시작하기", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.cgColor
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
            make.centerX.equalToSuperview().offset(18)
            make.centerY.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom).offset(3)
        }
        
        view.addSubview(kakaoSignUpButton)
        kakaoSignUpButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(65)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        kakaoSignUpButton.rounded(axis: .horizontal)
        
        kakaoSignUpButton.addSubview(kakaoImageView)
        kakaoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(appleSignUpButton)
        appleSignUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoSignUpButton.snp.top).offset(-14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        appleSignUpButton.rounded(axis: .horizontal)
        
        appleSignUpButton.addSubview(appleImageView)
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
        //Kakao
        kakaoSignUpButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.indicator.startAnimating()
                self?.viewModel.kakaoLogIn()
            })
            .disposed(by: disposeBag)
        
        viewModel.userAlreadyExist
            .subscribe(onNext:{ [weak self] userAlreadyExist in
                if userAlreadyExist {
                    self?.indicator.stopAnimating()
                    self?.userAlreadyExistAlert()
                }
            })
            .disposed(by: disposeBag)
        
        //Apple
        appleSignUpButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.indicator.startAnimating()
                self?.viewModel.appleLogIn()
            })
            .disposed(by: disposeBag)
        
        //공통
        viewModel.errorCatch
            .subscribe(onNext:{ [weak self] error in
                if error {
                    self?.indicator.stopAnimating()
                    self?.errorAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.signUpResult
            .subscribe(onNext:{ [weak self] result in
                if result {
                    self?.indicator.stopAnimating()
                    self?.presentVC(TabBarViewController())
                } else {
                    self?.indicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func userAlreadyExistAlert() {
        let alert = UIAlertController(title: "같은 이메일로 가입된 계정이 있어요", message: "로그인하기로 돌아가서 로그인해주세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        confirm.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}
