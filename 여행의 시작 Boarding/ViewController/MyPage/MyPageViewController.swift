//
//  MyPageViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

class MyPageViewController: UIViewController {

    let menuArr = ["내 NFT", "내 마일리지", "전문가 레벨", "환경설정"]
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var iconView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(named: "Search"), for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action:#selector(searchButtonPressed), for: .touchUpInside)
    }
    
    @objc func searchButtonPressed() {
        print("searchButton Pressed")
    }
    
    lazy var alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Alarm"), for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(alarmButtonPressed), for: .touchUpInside)
    }
    
    @objc func alarmButtonPressed() {
        print("alarmButton Pressed")
    }
    
    lazy var divider = UIView().then {
        $0.backgroundColor = myPageTableView.separatorColor
    }
    
    var userImageView = UIImageView().then {
        $0.image = UIImage(named: "User")
    }
    
    var userNameLabel = UILabel().then {
        $0.text = "박정현"
        $0.font = Pretendard.semiBold(24)
        $0.textColor = Gray.black
    }
    
    var userCommentLabel = UILabel().then {
        $0.text = "세상의 모든 아름다움을 담아가는 여행자입니다."
        $0.font = Pretendard.regular(14)
        $0.textColor = Gray.dark
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    var userAchievementStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    lazy var tableViewTopDivider = UIView().then {
        $0.backgroundColor = myPageTableView.separatorColor
    }
    
    var myPageTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.rowHeight = 60
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        myPageTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuTableViewCell")
        setViews()
        putUserAchievement()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        iconView.addSubview(searchButton)
        iconView.addSubview(alarmButton)
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(alarmButton.snp.left).offset(-12)
            make.top.equalToSuperview().offset(14)
        }
        alarmButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(14)
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        view.addSubview(userImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userCommentLabel)
        view.addSubview(userAchievementStackView)
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(divider).offset(28)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(110)
        }
        userImageView.rounded(axis: .horizontal)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(divider).offset(28)
            make.left.equalTo(userImageView.snp.right).offset(32)
        }
        userCommentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(9)
            make.left.equalTo(userImageView.snp.right).offset(32)
            make.width.equalTo(200)
        }
        userAchievementStackView.snp.makeConstraints { make in
            make.top.equalTo(userCommentLabel.snp.bottom).offset(9)
            make.left.equalTo(userImageView.snp.right).offset(32)
            make.width.equalTo(170)
            make.height.equalTo(24)
        }
        
        view.addSubview(tableViewTopDivider)
        tableViewTopDivider.snp.makeConstraints { make in
            make.top.equalTo(userAchievementStackView.snp.bottom).offset(44)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        view.addSubview(myPageTableView)
        myPageTableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewTopDivider.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    func putUserAchievement() {
        let userAchieveItem1 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🇰🇷 Lv.5"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        let userAchieveItem2 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "📷 Lv.7"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        let userAchieveItem3 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🏄‍♂️ Lv.5"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        userAchievementStackView.addArrangedSubview(userAchieveItem1)
        userAchievementStackView.addArrangedSubview(userAchieveItem2)
        userAchievementStackView.addArrangedSubview(userAchieveItem3)
    }
}

//MARK: - UITableView
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menuArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var vc = UIViewController()
        switch indexPath.row {
        case 0:
            vc = MyNFTViewController()
            vc.navigationItem.title = "내 NFT"
        case 1:
            vc = MyMileageViewController()
            vc.navigationItem.title = "내 마일리지"
        case 2:
            vc = ExpertLevelViewController()
            vc.navigationItem.title = "전문가 레벨"
        default:
            vc = ExpertLevelViewController()
            vc.navigationItem.title = "전문가 레벨"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
