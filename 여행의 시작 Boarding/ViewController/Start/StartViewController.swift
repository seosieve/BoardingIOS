//
//  StartViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit

class StartViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "TitleWhite")
    }
    
    var subLabel = UILabel().then {
        $0.text = "여행의 시작"
        $0.textColor = Gray.white.withAlphaComponent(0.8)
        $0.font = Pretendard.medium(14)
    }
    
    lazy var signUpButton = UIButton().then {
        $0.setBackgroundColor(Gray.white, for: .normal)
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(Boarding.lightBlue, for: .normal)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    @objc func signUpButtonPressed() {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var logInButton = UIButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.white.cgColor
        $0.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
    }
    
    @objc func logInButtonPressed() {
        let vc = LogInViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.gradient([Boarding.lightBlue, Boarding.blue], axis: .horizontal)
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
        
        view.addSubview(logInButton)
        logInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(65)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        logInButton.rounded(axis: .horizontal)
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(logInButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
        signUpButton.rounded(axis: .horizontal)
    }
}
