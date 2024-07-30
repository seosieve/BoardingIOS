//
//  AlarmViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/22/23.
//

import UIKit

class AlarmViewController: UIViewController {

    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "최신 알림"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var alarmView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.bright
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
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(alarmView)
        alarmView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
