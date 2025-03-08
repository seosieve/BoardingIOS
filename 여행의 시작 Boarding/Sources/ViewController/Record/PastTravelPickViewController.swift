//
//  PastTravelPickViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/23/23.
//

import UIKit

class PastTravelPickViewController: UIViewController {

    var titleResult = ""
    var locationResult = ""
    var durationResult = 1
    
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
        $0.text = "추가할 기록을 선택해주세요"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
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
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
    }
}
