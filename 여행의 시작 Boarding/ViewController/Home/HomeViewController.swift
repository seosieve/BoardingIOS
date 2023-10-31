//
//  HomeViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/05.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa
import FirebaseStorage
import FirebaseStorageUI

import FirebaseAuth

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var cellCount = 10
    var selectedCategory = ""
    
    let viewModel = HomeViewModel()
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
        $0.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 60, right: 0)
        $0.contentOffset = CGPoint(x: 0, y: -120)
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
    
    @objc func categorySelected(_ sender: UITapGestureRecognizer) {
        categoryStackView.arrangedSubviews.forEach { view in
            guard let button = view.viewWithTag(1) as? UIButton else { return }
            guard let label = view.viewWithTag(2) as? UILabel else { return }
            button.layer.borderWidth = 0
            label.font = Pretendard.regular(13)
            label.textColor = Gray.medium
        }
        
        guard let button = sender.view?.viewWithTag(1) as? UIButton else { return }
        guard let label = sender.view?.viewWithTag(2) as? UILabel else { return }
        if button.layer.borderWidth == 0 {
            button.layer.borderWidth = 2
            label.font = Pretendard.semiBold(13)
            label.textColor = Boarding.blue
            selectedCategory = label.text!
        } else {
            button.layer.borderWidth = 0
            label.font = Pretendard.regular(13)
            label.textColor = Gray.medium
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.isHidden = true
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
                let tap = UITapGestureRecognizer(target: self, action: #selector(categorySelected(_:)))
                tap.cancelsTouchesInView = false
                $0.addGestureRecognizer(tap)
            }
            
            let emojiButton = UIButton().then {
                $0.tag = 1
                $0.backgroundColor = Gray.bright
                $0.setTitle(Category.imoji[index], for: .normal)
                $0.titleLabel?.font = Pretendard.regular(30)
                $0.layer.borderColor = Boarding.blue.cgColor
            }
            
            let nameLabel = UILabel().then {
                $0.tag = 2
                $0.text = Category.name[index]
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.medium
            }
            
            subview.addSubview(emojiButton)
            emojiButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.centerX.equalToSuperview()
                make.width.height.equalTo(64)
            }
            emojiButton.rounded(axis: .horizontal)
            
            subview.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.top.equalTo(emojiButton.snp.bottom).offset(4)
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
        
        viewModel.items
            .bind(to: homeTableView.rx.items(cellIdentifier: "homeTableViewCell", cellType: HomeTableViewCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                if element.NFTID != "" {
                    self.viewModel.getAuther(auther: element.autherUid) { user in
                        cell.userNameLabel.text = user.name
                        cell.userImage.sd_setImage(with: URL(string: user.url), placeholderImage: nil, options: .scaleDownLargeImages)
                        //Add Image Tap Event
                        
                    }
                    
                    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                    tapGestureRecognizer.delegate = self
                    // Add this line!
                    cell.photoView.gestureRecognizers?.removeAll()
                    
//                    cell.photoView.isUserInteractionEnabled = true
//                    cell.photoView.addGestureRecognizer(tapGestureRecognizer)
                    
                    
                    
                    
                    cell.imageTapped = {
                        let vc = FullScreenViewController()
                        vc.url = URL(string: element.url)
                        vc.NFT = element
//                        vc.User = user
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.titleLabel.text = element.title
                    cell.contentLabel.text = element.content
                    cell.photoView.sd_setImage(with: URL(string: element.url), placeholderImage: nil, options: .scaleDownLargeImages)
                    cell.scoreLabel.text = String(element.starPoint)
                    cell.locationLabel.text = element.location
                    cell.userAchievementStackView.isHidden = false
                    cell.isUserInteractionEnabled = true
                } else {
                    cell.userAchievementStackView.isHidden = true
                    cell.isUserInteractionEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        homeTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    @objc func imageTapped() {
        print("aa")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("aaa")
        return touch.view is UITableView
    }
}

//MARK: - UITableView
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.items.value[indexPath.row].content
        if item == "" {
            return 640
        } else {
            let label = UILabel()
            label.text = item
            label.numberOfLines = 3
            label.font = Pretendard.regular(17)
            let maxWidth = view.frame.width - 40
            let maxSize = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            let labelSize = label.sizeThatFits(maxSize)
            
            return 640 + labelSize.height
        }
    }
}

//MARK: - UIScrollView
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.frame.origin.y + scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        iconView.layer.shadowOpacity = Float(level/2000)
    }
}
