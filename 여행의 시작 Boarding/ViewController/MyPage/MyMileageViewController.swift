//
//  MyMileageViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit

class MyMileageViewController: UIViewController {

    var divider = UIView().then {
        $0.backgroundColor = UITableView().separatorColor
    }
    
    var linkView = UIView()
    
    var linkMainLabel = UILabel().then {
        $0.text = "암호화폐 지갑을 연동해주세요"
        $0.font = Pretendard.medium(24)
        $0.textColor = Gray.dark
    }
    
    var linkSubLabel = UILabel().then {
        $0.text = "다른 유저들이 회원님의 NFT를\n사용하면 Mile 토큰을 받을 수 있습니다.\n리워드를 모아 새로운 여행을 떠나보세요!"
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.dark
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    lazy var linkButton = UIButton().then {
        $0.setTitle("연동하기", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.backgroundColor = Boarding.blue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(linkButtonPressed), for: .touchUpInside)
    }
    
    @objc func linkButtonPressed() {
        print("linkButton Pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setNavigationBar()
        self.view.backgroundColor = Gray.white
        setViews()
    }
    
    func setViews() {
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom())
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        view.addSubview(linkView)
        linkView.snp.makeConstraints { make in
            make.centerX.centerY.left.equalToSuperview()
            make.height.equalTo(280)
        }
        
        linkView.addSubview(linkMainLabel)
        linkView.addSubview(linkSubLabel)
        linkView.addSubview(linkButton)
        linkMainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        linkSubLabel.snp.makeConstraints { make in
            make.top.equalTo(linkMainLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(50)
        }
        linkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }
    }
}
