//
//  PastTravelLocationViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/23/23.
//

import UIKit

class PastTravelLocationViewController: UIViewController {

    var titleResult = ""
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "어느 지역을 다녀오셨나요?"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var titleTextField = UITextField().then {
        $0.placeholder = "다녀오신 나라를 입력해주세요."
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(titleTextFieldChanged), for: .editingChanged)
    }
    
    @objc func titleTextFieldChanged() {
        if titleTextField.text == "" {
            titleUnderLine.backgroundColor = Gray.medium
            nextButton.isEnabled = false
        } else {
            titleUnderLine.backgroundColor = Boarding.blue
            nextButton.isEnabled = true
        }
    }
    
    var titleUnderLine = UIView().then {
        $0.backgroundColor = Gray.medium
    }
    
    lazy var nextButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    @objc func nextButtonPressed() {
        titleTextField.resignFirstResponder()
        let vc = PastTravelDurationViewController()
        vc.titleResult = titleResult
        vc.locationResult = titleTextField.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        titleTextField.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        titleTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(310)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.nextButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(30)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(titleUnderLine)
        titleUnderLine.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(2)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        nextButton.rounded(axis: .horizontal)
    }
}

//MARK: - UITextFieldDelegate
extension PastTravelLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            nextButtonPressed()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
