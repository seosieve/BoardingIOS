//
//  NewHomeViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/05.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

class NewHomeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
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
    
    var locationImageView = UIImageView().then {
        $0.image = UIImage(named: "Location")
    }
    
    var locationButton = UIButton().then {
        $0.setTitle("전세계", for: .normal)
        $0.setImage(UIImage(named: "Triangle2"), for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(27)
        $0.setTitleColor(Gray.black, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        $0.semanticContentAttribute = .forceRightToLeft
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
    
    var alarmPointView = UIView().then {
        $0.backgroundColor = Boarding.red
    }
    
    var homeTableView = UITableView().then {
        $0.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var categoryScrollView = UIScrollView().then {
        $0.backgroundColor = Gray.white
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentOffset = CGPoint(x: -20, y: 0)
    }
    
    var categoryStackView = UIStackView().then {
        $0.backgroundColor = Gray.white
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.isHidden = true
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "homeTableViewCell")
        setViews()
        setRx()
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
        iconView.addSubview(locationImageView)
        iconView.addSubview(locationButton)
        locationImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(25)
            make.centerY.equalToSuperview()
            make.height.equalTo(26)
        }
        locationButton.snp.makeConstraints { make in
            make.left.equalTo(locationImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        iconView.addSubview(searchButton)
        iconView.addSubview(alarmButton)
        iconView.addSubview(alarmPointView)
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
        alarmPointView.snp.makeConstraints { make in
            make.width.height.equalTo(7)
            make.right.equalToSuperview().offset(-27.5)
            make.top.equalToSuperview().offset(12)
        }
        alarmPointView.rounded(axis: .horizontal)
        
        view.insertSubview(homeTableView, belowSubview: iconView)
        homeTableView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        homeTableView.addSubview(categoryScrollView)
        categoryScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-120)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(120)
        }
        
        categoryScrollView.addSubview(categoryStackView)
        categoryStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        for index in 0..<Category.count {
            let subview = UIView().then {
                $0.backgroundColor = Gray.white
            }
            
            let emojiLabel = UILabel().then {
                $0.backgroundColor = Gray.bright
                $0.text = Category.imoji[index]
                $0.font = Pretendard.regular(30)
                $0.textAlignment = .center
            }
            
            let nameLabel = UILabel().then {
                $0.text = Category.name[index]
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.medium
            }
            
            subview.addSubview(emojiLabel)
            emojiLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.centerX.equalToSuperview()
                make.width.height.equalTo(64)
            }
            emojiLabel.rounded(axis: .horizontal)
            
            subview.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(emojiLabel.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
            }
            categoryStackView.addArrangedSubview(subview)
        }
        
        let categoryDivider = divider()
        homeTableView.addSubview(categoryDivider)
        categoryDivider.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setRx() {
        locationButton.rx.tap
            .subscribe(onNext: {
                let vc = SetLocationViewController()
                vc.modalPresentationStyle = .automatic
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let vc = FullScreenViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UIScrollView
extension NewHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.frame.origin.y + scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        iconView.layer.shadowOpacity = Float(level/2000)
        print(level)
    }
}
