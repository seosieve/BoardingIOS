//
//  NewHomeViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/05.
//

import UIKit
import FirebaseAuth

class NewHomeViewController: UIViewController {
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var iconView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.shadowOffset = CGSize(width:0, height:12)
        $0.layer.shadowRadius = 6
        $0.layer.shadowColor = Gray.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOpacity = 0
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
    
    var homeTableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeTableViewCell")
        setViews()
        
        
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL
            print(uid)
            print(email)
            print(photoURL)
        } else {
            print("aaaaa")
        }
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
            make.centerY.equalToSuperview()
        }
        alarmButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
        }
        
//        view.insertSubview(homeScrollView, belowSubview: iconView)
//        homeScrollView.addSubview(homeContentView)
//        homeScrollView.snp.makeConstraints { make in
//            make.left.right.bottom.equalToSuperview()
//            make.top.equalTo(statusBarView.snp.bottom)
//        }
//        homeContentView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(950)
//        }
        
        view.insertSubview(homeTableView, belowSubview: iconView)
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(statusBarView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - UITableView
extension NewHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 720
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UIScrollView
extension NewHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.frame.origin.y + scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        iconView.layer.shadowOpacity = Float(level/2000)
    }
}
