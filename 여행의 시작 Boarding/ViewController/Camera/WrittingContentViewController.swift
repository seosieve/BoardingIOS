//
//  WrittingContentViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit

class WrittingContentViewController: UIViewController {

    var placeHolder = "내용을 작성해주세요."
    var titleResult = ""
    
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
        $0.text = placeHolder
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
        $0.tintColor = Boarding.blue
        $0.isScrollEnabled = false
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
        vc.titleResult.accept(titleResult)
        vc.contentResult.accept(contentTextView.text)
        vc.titleTextLabel.textColor = Gray.dark
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
            make.top.equalTo(contentLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        textViewDidChange(contentTextView)
        
        view.addSubview(contentUnderLine)
        contentUnderLine.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(5)
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
        if textView.text == "" || textView.text == "내용을 작성해주세요." {
            contentUnderLine.backgroundColor = Gray.medium
            nextButton.isEnabled = false
        } else {
            contentUnderLine.backgroundColor = Boarding.blue
            nextButton.isEnabled = true
        }
        
        //글자수에 따라 TextView height 조정
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimateSize = textView.sizeThatFits(size)
        textView.snp.updateConstraints { make in
            make.height.equalTo(estimateSize.height)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.textColor = Gray.light
            contentTextView.text = placeHolder
        } else if textView.text == placeHolder {
            contentTextView.textColor = Gray.black
            contentTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeHolder {
            contentTextView.textColor = Gray.light
            contentTextView.text = placeHolder
        }
    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        contentTextView.resignFirstResponder()
        return true
    }
}
