//
//  BlockedUserViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class BlockedUserViewController: UIViewController {

    let viewModel = BlockedUserViewModel()
    let disposeBag = DisposeBag()
    
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
        $0.text = "차단 유저 목록"
        $0.font = Pretendard.semiBold(18)
        $0.textColor = Gray.black
    }
    
    var blockedUserTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.rowHeight = 70
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        blockedUserTableView.register(BlockedUserTableViewCell.self, forCellReuseIdentifier: "blockedUserTableViewCell")
        setViews()
        setRx()
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
        
        view.addSubview(blockedUserTableView)
        blockedUserTableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.left.centerX.bottom.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.items
            .bind(to: blockedUserTableView.rx.items(cellIdentifier: "blockedUserTableViewCell", cellType: BlockedUserTableViewCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                if element != "" {
                    self.viewModel.makeBlockedUser(userUid: element) { user in
                        cell.userImage.sd_setImage(with: URL(string: user.url), placeholderImage: nil, options: .scaleDownLargeImages)
                        cell.userNameLabel.text = user.name
                    }
                    cell.unblockTapped = {
                        self.unblockAlert(target: element)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func unblockAlert(target: String) {
        let alert = UIAlertController(title: "유저의 차단을 해제하시겠어요?", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "해제", style: .default) { action in
            self.viewModel.unblockUser(target: target)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}
