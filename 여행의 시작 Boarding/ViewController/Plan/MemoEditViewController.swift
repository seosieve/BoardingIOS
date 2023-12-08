//
//  MemoEditViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/08.
//

import UIKit
import RxSwift
import RxCocoa

class MemoEditViewController: UIViewController {
    
    var planID = ""
    var memoArray = [String]()
    var placeHolder = "메모를 작성해주세요"
    
    lazy var viewModel = MemoEditViewModel(planID: self.planID)
    let disposeBag = DisposeBag()
    
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true)
    }
    
    var modalView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var modalIndicator = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var addPlanLabel = UILabel().then {
        $0.text = "메모 수정"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var numberLabel = UILabel().then {
        $0.text = "위치"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.semiDark
    }
    
    var numberBorderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    lazy var numberTextField = immovableTextField().then {
        $0.text = "1"
        $0.inputView = dayPickerView
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.black
        $0.tintColor = .clear
    }
    
    var numberPickerImage = UIImageView().then {
        $0.image = UIImage(named: "Triangle")
    }
    
    lazy var dayPickerView = UIPickerView()
    
    var memoLabel = UILabel().then {
        $0.text = "메모"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.semiDark
    }
    
    var memoBorderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    lazy var memoTextView = UITextView().then {
        $0.text = placeHolder
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.light
        $0.tintColor = Boarding.blue
        $0.isScrollEnabled = false
    }
    
    lazy var completeButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.medium(19)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextView.delegate = self
        dayPickerView.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
        setMemo()
        setRx()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        let inset = memoTextView.isFirstResponder ? 310 : 235
        
        UIView.animate(withDuration: 0.3) {
            self.completeButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(inset)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.completeButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(30)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func setViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
        }
        modalView.makeModalCircular()
        
        modalView.addSubview(modalIndicator)
        modalIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        modalIndicator.rounded(axis: .horizontal)
        
        modalView.addSubview(addPlanLabel)
        addPlanLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.top.equalTo(addPlanLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(numberBorderView)
        numberBorderView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(12)
            make.left.equalTo(numberLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        numberBorderView.addSubview(numberTextField)
        numberTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.center.equalToSuperview()
        }
        
        numberBorderView.addSubview(numberPickerImage)
        numberPickerImage.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
        
        modalView.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(numberBorderView.snp.bottom).offset(20)
            make.left.equalTo(numberBorderView)
        }
        
        modalView.addSubview(memoBorderView)
        memoBorderView.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(12)
            make.left.equalTo(memoLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
        }
        
        memoBorderView.addSubview(memoTextView)
        memoTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.bottom.lessThanOrEqualToSuperview().offset(20)
        }
        
        modalView.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(memoBorderView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
    }
    
    func setMemo() {
        memoTextView.textColor = memoArray.first == "" ? Gray.light : Gray.black
        memoTextView.text = memoArray.first == "" ? placeHolder : memoArray.first
    }
    
    func setRx() {
        completeButton.rx.tap
            .subscribe(onNext: {
                if let index = Int(self.numberTextField.text!) {
                    let memo = self.memoTextView.text == self.placeHolder ? "" : self.memoTextView.text!
                    self.memoArray[index-1] = memo
                }
                self.viewModel.editMemo(memoArray: self.memoArray)
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITextViewDelegate
extension MemoEditViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count - range.length + text.count
        if newLength > 100 {
            return false
        }
        if text == "\n" {
            memoTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            memoTextView.textColor = Gray.light
            memoTextView.text = placeHolder
        } else if textView.text == placeHolder {
            memoTextView.textColor = Gray.black
            memoTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeHolder {
            memoTextView.textColor = Gray.light
            memoTextView.text = placeHolder
        }
    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        memoTextView.resignFirstResponder()
        return true
    }
}

//MARK: - UIPickerViewDelegate
extension MemoEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return memoArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberTextField.text = String(row+1)
        memoTextView.text = memoArray[row]
        if memoArray[row] == "" {
            memoTextView.textColor = Gray.light
            memoTextView.text = placeHolder
        } else {
            memoTextView.textColor = Gray.black
            memoTextView.text = memoArray[row]
        }
    }
}
