//
//  AgreementViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/29.
//

import UIKit

class AgreementViewController: UIViewController {
    
    var agreement = [false, false, false]
    
    var titleLabel = UILabel().then {
        $0.text = "회원가입을 위해 \n약관에 동의해주세요"
        $0.font = Pretendard.semiBold(30)
        $0.textColor = Gray.black
        $0.numberOfLines = 2
        $0.withLineSpacing(16)
    }
    
    var termsStackView = UIStackView().then {
        $0.backgroundColor = Gray.white
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        sender.touchAnimation()
        agreement[sender.tag-1] = sender.isSelected
        
        if agreement.contains(false) {
            completeButton.isEnabled = false
        } else {
            completeButton.isEnabled = true
        }
    }
    
    @objc func detailButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 4:
            let vc = TermsViewController()
            vc.terms = "이용약관"
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let vc = TermsViewController()
            vc.terms = "개인정보 보호 정책"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = TermsViewController()
            vc.terms = "커뮤니티 이용규칙"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    lazy var completeButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    @objc func completeButtonPressed() {
        let vc = TabBarViewController()
        self.presentVC(vc, transition: .crossDissolve)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        setViews()
    }
    
    func setViews() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
        
        view.addSubview(termsStackView)
        termsStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(completeButton.snp.top).offset(-32)
        }
        let title = ["Boarding 서비스 이용약관 (필수)", "개인정보처리방침 동의 (필수)", "커뮤니티 이용규칙 동의 (필수)"]
        for index in 0..<3 {
            let subview = UIView()
            
            lazy var checkButton = UIButton().then {
                $0.tag = index+1
                $0.setImage(UIImage(named: "Check"), for: .normal)
                $0.setImage(UIImage(named: "CheckFilled"), for: .selected)
                $0.addTarget(self, action: #selector(checkButtonPressed(_:)), for: .touchUpInside)
            }
            
            let titleLabel = UILabel().then {
                $0.text = title[index]
                $0.font = Pretendard.medium(17)
                $0.textColor = Gray.dark
            }
            
            lazy var detailButton = UIButton().then {
                $0.tag = index+4
                $0.setTitle("보기", for: .normal)
                $0.titleLabel?.font = Pretendard.regular(16)
                $0.setTitleColor(Gray.light, for: .normal)
                let attributedString = NSMutableAttributedString(string: "보기")
                attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 2))
                $0.setAttributedTitle(attributedString, for: .normal)
                $0.addTarget(self, action: #selector(detailButtonPressed(_:)), for: .touchUpInside)
            }
            
            subview.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            
            subview.addSubview(checkButton)
            checkButton.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.width.height.equalTo(28)
            }
            
            subview.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(checkButton.snp.right).offset(14)
                make.centerY.equalToSuperview()
            }
            
            subview.addSubview(detailButton)
            detailButton.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            termsStackView.addArrangedSubview(subview)
        }
    }
}
