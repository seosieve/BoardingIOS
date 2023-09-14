//
//  SignUpViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/14.
//

import UIKit

class SignUpViewController: UIViewController {

    var completeButton = UIButton().then {
        $0.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.setNavigationBar()
        setViews()
    }
    
    func setViews() {
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
