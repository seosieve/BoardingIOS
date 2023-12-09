//
//  ReportViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/04.
//

import UIKit
import RxSwift
import RxCocoa

class ReportViewController: UIViewController {

    var step = 0
    var NFTID = ""
    var authorUid = ""
    var selectedReason = ""
    var placeHolder = "내용을 입력해주세요."
    var blockUser = ""
    
    let viewModel = ReportViewModel()
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
    
    var reportLabel = UILabel().then {
        $0.text = "신고 사유를 선택해주세요."
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var containerView = UIView()
    
    var reportReasonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func reportReasonPressed(_ sender: UITapGestureRecognizer) {
        reportReasonStackView.arrangedSubviews.forEach { view in
            guard let borderView = view.viewWithTag(1) else { return }
            guard let sublayers = borderView.layer.sublayers else { return }
            guard let label = view.viewWithTag(2) as? UILabel else { return }
            for layer in sublayers where layer.isKind(of: CAGradientLayer.self) || layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
            borderView.layer.borderWidth = 1
            label.font = Pretendard.regular(17)
            label.textColor = Gray.medium
        }
        
        guard let borderView = sender.view?.viewWithTag(1) as? UIView else { return }
        guard let label = sender.view?.viewWithTag(2) as? UILabel else { return }
        
        if label.text == selectedReason {
            selectedReason = ""
            nextButton.isEnabled = false
        } else {
            selectedReason = label.text!
            borderView.gradientBorder()
            borderView.layer.borderWidth = 0
            label.font = Pretendard.semiBold(17)
            label.textColor = Gray.black
            nextButton.isEnabled = true
        }
    }
    
    var reportDetailBorderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    lazy var reportDetailTextView = UITextView().then {
        $0.text = placeHolder
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.light
        $0.tintColor = Boarding.blue
        $0.isScrollEnabled = false
    }
    
    var blockUserLabel = UILabel().then {
        $0.text = "유저를 차단하면 해당 유저가 작성한\n모든 게시물이 피드에 뜨지 않아요."
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
        $0.numberOfLines = 2
        $0.withLineSpacing(4)
    }
    
    var blockUserStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func blockUserPressed(_ sender: UITapGestureRecognizer) {
        blockUserStackView.arrangedSubviews.forEach { view in
            guard let borderView = view.viewWithTag(1) else { return }
            guard let sublayers = borderView.layer.sublayers else { return }
            guard let label = view.viewWithTag(2) as? UILabel else { return }
            for layer in sublayers where layer.isKind(of: CAGradientLayer.self) || layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
            borderView.layer.borderWidth = 1
            label.font = Pretendard.regular(17)
            label.textColor = Gray.medium
        }
        
        guard let view = sender.view as? StringStoredView else { return }
        guard let borderView = sender.view?.viewWithTag(1) as? UIView else { return }
        guard let label = sender.view?.viewWithTag(2) as? UILabel else { return }
        
        if view.storedString != blockUser {
            blockUser = view.storedString
            borderView.gradientBorder()
            borderView.layer.borderWidth = 0
            label.font = Pretendard.semiBold(17)
            label.textColor = Gray.black
            nextButton.isEnabled = true
        }
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
        if step == 0 {
            step = 1
            nextButton.isEnabled = false
            reportLabel.text = "신고 내용을 작성해주세요."
            UIView.animate(withDuration: 0.3) {
                self.containerView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(-self.view.frame.width)
                }
                self.view.layoutIfNeeded()
            }
        } else if step == 1 {
            step = 2
            reportDetailTextView.resignFirstResponder()
            reportLabel.text = "해당 유저를 차단하시겠어요?"
            UIView.animate(withDuration: 0.3) {
                self.containerView.snp.updateConstraints { make in
                    make.left.equalToSuperview().offset(-self.view.frame.width*2)
                }
                self.view.layoutIfNeeded()
            }
            nextButton.setTitle("완료", for: .normal)
        } else {
            indicator.startAnimating()
            view.isUserInteractionEnabled = false
            if blockUser == "yes" {
                viewModel.addBlockedUser(authorUid)
            }
            viewModel.writeReport(NFTID: NFTID, authorUid: authorUid, reason: selectedReason, detail: reportDetailTextView.text)
            viewModel.addReportCount(NFTID: NFTID)
        }
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        reportDetailTextView.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
        setRx()
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
        
        modalView.addSubview(reportLabel)
        reportLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(reportLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(0)
            make.width.equalTo(view.frame.width * 3)
            make.height.equalTo(220)
        }
        
        containerView.addSubview(reportReasonStackView)
        reportReasonStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(view.frame.width - 40)
            make.bottom.equalToSuperview()
        }
        let reportReason = ["잘못된 정보에요", "광고성 글이에요", "부적절한 사진이에요", "기타"]
        for index in 0..<4 {
            lazy var subview = UIView().then {
                let tap = UITapGestureRecognizer(target: self, action: #selector(reportReasonPressed(_:)))
                $0.addGestureRecognizer(tap)
            }
            lazy var borderView = UIView().then {
                $0.tag = 1
                $0.backgroundColor = Gray.white
                $0.layer.borderWidth = 1
                $0.layer.borderColor = Gray.semiLight.cgColor
                $0.layer.cornerRadius = 8
            }
            lazy var mainLabel = UILabel().then {
                $0.tag = 2
                $0.text = reportReason[index]
                $0.font = Pretendard.regular(17)
                $0.textColor = Gray.medium
            }
            
            subview.addSubview(borderView)
            borderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            subview.addSubview(mainLabel)
            mainLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24)
                make.centerY.equalToSuperview()
            }
            reportReasonStackView.addArrangedSubview(subview)
        }
        
        containerView.addSubview(reportDetailBorderView)
        reportDetailBorderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width - 40)
            make.bottom.equalToSuperview()
        }
        
        reportDetailBorderView.addSubview(reportDetailTextView)
        reportDetailTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
        }
        
        containerView.addSubview(blockUserLabel)
        blockUserLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20 + view.frame.width * 2)
            make.width.equalTo(view.frame.width - 40)
        }
        
        containerView.addSubview(blockUserStackView)
        blockUserStackView.snp.makeConstraints { make in
            make.top.equalTo(blockUserLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20 + view.frame.width * 2)
            make.width.equalTo(view.frame.width - 40)
            make.bottom.equalToSuperview()
        }
        let block = [("네 차단할게요", "yes"), ("아니요 괜찮아요", "no")]
        for index in 0..<2 {
            lazy var subview = StringStoredView().then {
                $0.storedString = block[index].1
                let tap = UITapGestureRecognizer(target: self, action: #selector(blockUserPressed(_:)))
                $0.addGestureRecognizer(tap)
            }
            lazy var borderView = UIView().then {
                $0.tag = 1
                $0.backgroundColor = Gray.white
                $0.layer.borderWidth = 1
                $0.layer.borderColor = Gray.semiLight.cgColor
                $0.layer.cornerRadius = 8
            }
            lazy var mainLabel = UILabel().then {
                $0.tag = 2
                $0.text = block[index].0
                $0.font = Pretendard.regular(17)
                $0.textColor = Gray.medium
            }
            
            subview.addSubview(borderView)
            borderView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            subview.addSubview(mainLabel)
            mainLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(24)
                make.centerY.equalToSuperview()
            }
            blockUserStackView.addArrangedSubview(subview)
        }
        
        modalView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        nextButton.rounded(axis: .horizontal)
        
        modalView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.processCompleted
            .subscribe(onNext: {
                self.indicator.stopAnimating()
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITextViewDelegate
extension ReportViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count - range.length + text.count
        if newLength > 100 {
            return false
        }
        if text == "\n" {
            reportDetailTextView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" || textView.text == placeHolder {
            nextButton.isEnabled = false
        } else {
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
            reportDetailTextView.textColor = Gray.light
            reportDetailTextView.text = placeHolder
        } else if textView.text == placeHolder {
            reportDetailTextView.textColor = Gray.black
            reportDetailTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == placeHolder {
            reportDetailTextView.textColor = Gray.light
            reportDetailTextView.text = placeHolder
        }
    }
    
    func textViewShouldReturn(_ textField: UITextField) -> Bool {
        reportDetailTextView.resignFirstResponder()
        return true
    }
}
