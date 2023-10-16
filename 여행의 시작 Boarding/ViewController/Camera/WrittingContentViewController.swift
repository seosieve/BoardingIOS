//
//  WrittingContentViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit
import Then
import SnapKit

class WrittingContentViewController: UIViewController {

    var titleString = ""
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var contentLabel = UILabel().then {
        $0.text = "내용을 작성해주세요."
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var contentTextView = UITextView().then {
        $0.text = "내용을 작성해주세요."
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
    }
    
    var contentUnderLine = UIView().then {
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
        let vc = self.navigationController!.viewControllers[1] as! WrittingViewController
        vc.titleTextLabel.text = self.titleString
        vc.titleTextLabel.textColor = Gray.dark
        vc.contentTextLabel.text = self.contentTextView.text
        vc.contentTextLabel.textColor = Gray.dark
        self.navigationController?.popToViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.isNavigationBarHidden = true
        contentTextView.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
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
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(100)
        }
        
        view.addSubview(contentUnderLine)
        contentUnderLine.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
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

//MARK: - UITextViewDelegate
extension WrittingContentViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            contentUnderLine.backgroundColor = Gray.medium
            nextButton.isEnabled = false
        } else {
            contentUnderLine.backgroundColor = Boarding.blue
            nextButton.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.textColor = Gray.light
            contentTextView.text = "내용을 작성해주세요."
        } else if textView.text == "내용을 작성해주세요." {
            contentTextView.textColor = Gray.dark
            contentTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == "내용을 작성해주세요." {
            contentTextView.textColor = Gray.light
            contentTextView.text = "내용을 작성해주세요."
        }
    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.resignFirstResponder()
        return true
    }
}
