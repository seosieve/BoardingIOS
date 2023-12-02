//
//  TermsViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/02.
//

import UIKit

class TermsViewController: UIViewController {

    var terms = ""
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = terms
        $0.font = Pretendard.semiBold(18)
        $0.textColor = Gray.semiDark
    }
    
    var termsScrollView = UIScrollView()
    
    var termsContentView = UIView()
    
    lazy var termsLabel = UILabel().then {
        let termsContent = terms == "이용약관" ? Terms.ConditionsOfUse : Terms.privacyPolicy
        $0.text = termsContent
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.medium
        let attrString = NSMutableAttributedString(string: $0.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        attrString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        setViews()
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
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        let termsDivider = divider()
        view.addSubview(termsDivider)
        termsDivider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        view.addSubview(termsScrollView)
        termsScrollView.snp.makeConstraints { make in
            make.top.equalTo(termsDivider.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        termsScrollView.addSubview(termsContentView)
        termsContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        termsContentView.addSubview(termsLabel)
        termsLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
