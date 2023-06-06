//
//  MyNFTViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit

class MyNFTViewController: UIViewController {

    var countLabel = UILabel().then {
        $0.text = "총 72개"
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.dark
    }
    
    var sortLabel = UILabel().then {
        $0.text = "등록순"
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.dark
    }
    
    var divider = UIView().then {
        $0.backgroundColor = UITableView().separatorColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setNavigationBar()
        self.view.backgroundColor = Gray.white
        setViews()
    }
    
    func setViews() {
        view.addSubview(countLabel)
        view.addSubview(sortLabel)
        view.addSubview(divider)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom() + 11)
            make.left.equalToSuperview().offset(24)
        }
        sortLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom() + 11)
            make.right.equalToSuperview().offset(-24)
        }
        divider.snp.makeConstraints { make in
            make.top.equalTo(sortLabel.snp.bottom).offset(11)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }

}
