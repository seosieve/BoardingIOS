//
//  LogInViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKUser

class LogInViewController: UIViewController {

    let viewModel = LogInViewModel()
    let disposeBag = DisposeBag()
    
    var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "TitleGradient")
    }
    
    var subLabel = UILabel().then {
        $0.text = "여행의 시작"
        $0.textColor = Gray.light
        $0.font = Pretendard.medium(14)
    }
    
    var appleLogInButton = UIButton().then {
        $0.setTitle("Apple 로그인", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.cgColor
        $0.layer.cornerRadius = 12
    }
    
    var appleImageView = UIImageView().then {
        $0.image = UIImage(named: "Apple")
    }
    
    lazy var kakaoLogInButton = UIButton().then {
        $0.setTitle("Kakao 로그인", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.cgColor
        $0.layer.cornerRadius = 12
    }
    
    var kakaoImageView = UIImageView().then {
        $0.image = UIImage(named: "Kakao")
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
        
        view.addSubview(kakaoLogInButton)
        kakaoLogInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(65)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        
        kakaoLogInButton.addSubview(kakaoImageView)
        kakaoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(appleLogInButton)
        appleLogInButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLogInButton.snp.top).offset(-14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        
        appleLogInButton.addSubview(appleImageView)
        appleImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setRx() {
        kakaoLogInButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] in
                self?.viewModel.kakaoLogIn()
            })
            .disposed(by: disposeBag)
        
        viewModel.kakaoLogInCompleted
            .subscribe(onNext:{ [weak self] LogInCompleted in
                if LogInCompleted {
                    self?.presentVC(TabBarViewController())
                } else {
                    self?.errorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "예상치 못한 에러가 발생했어요", message: "앱을 종료 후 다시 한 번 시도해주세요", preferredStyle: .alert)
        let logout = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(logout)
        logout.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}
