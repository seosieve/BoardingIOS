//
//  EditProfileViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/12/23.
//

import UIKit

class EditProfileViewController: UIViewController {

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
        $0.text = "프로필 편집"
        $0.font = Pretendard.semiBold(18)
        $0.textColor = Gray.black
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
        
        let divider = divider()
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
