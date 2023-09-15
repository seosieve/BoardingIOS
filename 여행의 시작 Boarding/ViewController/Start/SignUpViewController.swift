//
//  SignUpViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit

class SignUpViewController: UIViewController {

    let viewModel = SignUpViewModel()
    
    var emailTextField = UITextField().then {
        $0.placeholder = "이메일을 입력해주세요."
        $0.font = Pretendard.regular(16)
        $0.backgroundColor = Gray.light.withAlphaComponent(0.3)
        $0.textColor = Gray.dark
        $0.tintColor = Gray.dark
        $0.layer.cornerRadius = 12
    }
    
    var passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.font = Pretendard.regular(16)
        $0.backgroundColor = Gray.light.withAlphaComponent(0.3)
        $0.textColor = Gray.dark
        $0.tintColor = Gray.dark
        $0.layer.cornerRadius = 12
    }
    
    var errorLabel = UILabel().then {
        $0.textColor = .red
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(16)
        $0.backgroundColor = Boarding.blue
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        viewModel.createUser(email: emailTextField.text!, password: passwordTextField.text!) { error in
            if let error = error {
                self.errorLabel.text = error
            } else {
                print("complete")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.setNavigationBar()
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func setViews() {
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(400)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
        }
        
        view.addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-70)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(100)
            make.height.equalTo(45)
        }
    }
}
