//
//  LogInViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LogInViewController: UIViewController {

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
        $0.addTarget(self, action: #selector(kakaoLogInButtonPressed), for: .touchUpInside)
    }
    
    @objc func kakaoLogInButtonPressed() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오톡으로 로그인 성공")
                    _ = oauthToken
                    
                    
                    let homeVC = TabBarViewController()
                    homeVC.modalPresentationStyle = .fullScreen
                    homeVC.modalTransitionStyle = .crossDissolve
                    self.present(homeVC, animated: true, completion: nil)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    _ = oauthToken
                }
            }
        }
    }
    
    var kakaoImageView = UIImageView().then {
        $0.image = UIImage(named: "Kakao")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.setNavigationBar()
        setViews()
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
}
