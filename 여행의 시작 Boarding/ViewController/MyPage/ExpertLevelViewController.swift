//
//  ExpertLevelViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit

class ExpertLevelViewController: UIViewController {

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
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom())
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
    }
}
