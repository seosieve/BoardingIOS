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

protocol SearchDelegate: AnyObject {
    func searchNFT(word: String)
    func searchNFT(country: String, city: String)
}

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
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
        $0.image = UIImage(named: "HomeBlueLocation")
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
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func categorySelected(_ sender: UITapGestureRecognizer) {
        guard let button = sender.view?.viewWithTag(1) as? UIButton else { return }
        guard let label = sender.view?.viewWithTag(2) as? UILabel else { return }
        
        if label.text == selectedCategory {
            selectedCategory = ""
            button.isSelected = false
            button.layer.borderWidth = 0
            label.font = Pretendard.regular(13)
            label.textColor = Gray.medium
            viewModel.getAllNFT()
        } else {
            categoryStackView.arrangedSubviews.forEach { view in
                guard let button = view.viewWithTag(1) as? UIButton else { return }
                guard let label = view.viewWithTag(2) as? UILabel else { return }
                button.isSelected = false
                button.layer.borderWidth = 0
                label.font = Pretendard.regular(13)
                label.textColor = Gray.medium
            }
            selectedCategory = label.text!
            button.isSelected = true
            button.layer.borderWidth = 2
            label.font = Pretendard.semiBold(13)
            label.textColor = Boarding.blue
            viewModel.getNFTbyCategory(selectedCategory)
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
            make.width.lessThanOrEqualTo(230)
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
        for index in 0..<CategoryInfo.count {
            let subview = UIView().then {
                $0.backgroundColor = Gray.white
                let tap = UITapGestureRecognizer(target: self, action: #selector(categorySelected(_:)))
                tap.cancelsTouchesInView = false
                $0.addGestureRecognizer(tap)
            }
            
            let emojiButton = UIButton().then {
                $0.tag = 1
                $0.setBackgroundColor(Gray.bright, for: .normal)
                $0.setBackgroundColor(Boarding.blue.withAlphaComponent(0.2), for: .selected)
                $0.layer.borderColor = Boarding.blue.cgColor
                $0.adjustsImageWhenHighlighted = false
            }
            
            let categoryImage = UIImageView().then {
                $0.image = CategoryInfo.image[index]
            }
            
            let nameLabel = UILabel().then {
                $0.tag = 2
                $0.text = CategoryInfo.name[index]
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.medium
            }
            
            subview.snp.makeConstraints { make in
                make.width.equalTo(64)
            }
            
            subview.addSubview(emojiButton)
            emojiButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.left.centerX.equalToSuperview()
                make.height.equalTo(64)
            }
            emojiButton.rounded(axis: .horizontal)
            
            emojiButton.addSubview(categoryImage)
            categoryImage.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
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
                vc.delegate = self
                vc.modalPresentationStyle = .automatic
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap
            .subscribe(onNext: {
                let vc = SearchViewController()
                vc.delegate = self
                vc.modalPresentationStyle = .automatic
                vc.modalTransitionStyle = .coverVertical
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: homeTableView.rx.items(cellIdentifier: "homeTableViewCell", cellType: HomeTableViewCell.self)) { (row, element, cell) in
                cell.selectionStyle = .none
                if element.NFTID != "" {
                    self.viewModel.getAuthor(author: element.authorUid) { user in
                        cell.userNameLabel.text = user.name
                        cell.userImage.sd_setImage(with: URL(string: user.url), placeholderImage: nil, options: .scaleDownLargeImages)
                        cell.photoTapped = { [weak self] in
                            self?.goToFullScreen(url: URL(string: element.url), NFT: element, user: user)
                        }
                    }
                    cell.makeInteractionCount([element.reports, element.comments, element.likes, element.saves])
                    cell.iconTapped = { [weak self] sender in
                        self?.iconInteraction(sender, element.NFTID, element.authorUid)
                    }
                    cell.titleLabel.text = element.title
                    cell.contentLabel.text = element.content
                    cell.photoView.sd_setImage(with: URL(string: element.url), placeholderImage: nil, options: .scaleDownLargeImages)
                    cell.scoreLabel.text = String(Double(element.starPoint))
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
    
    func goToFullScreen(url: URL?, NFT: NFT, user: User) {
        let vc = HomeFullScreenViewController()
        vc.url = url
        vc.NFT = NFT
        vc.user = user
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func iconInteraction(_ sender: UIButton, _ NFTID: String, _ authorUid: String) {
        switch sender.tag {
        case 0:
            if viewModel.userUid == authorUid { break }
            let vc = ReportViewController()
            vc.authorUid = authorUid
            vc.NFTID = NFTID
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        case 1:
            break
        case 2:
            sender.isSelected.toggle()
            sender.touchAnimation()
        default:
            let vc = AddMyPlanViewController()
            vc.NFTID = NFTID
            vc.modalPresentationStyle = .automatic
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        }
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

//MARK: - searchDelegate
extension HomeViewController: SearchDelegate {
    func searchNFT(word: String) {
        categoryStackView.arrangedSubviews.forEach { view in
            guard let button = view.viewWithTag(1) as? UIButton else { return }
            guard let label = view.viewWithTag(2) as? UILabel else { return }
            button.isSelected = false
            button.layer.borderWidth = 0
            label.font = Pretendard.regular(13)
            label.textColor = Gray.medium
        }
        viewModel.getNFTbyWord(word)
    }
    
    func searchNFT(country: String, city: String) {
        categoryStackView.arrangedSubviews.forEach { view in
            guard let button = view.viewWithTag(1) as? UIButton else { return }
            guard let label = view.viewWithTag(2) as? UILabel else { return }
            button.isSelected = false
            button.layer.borderWidth = 0
            label.font = Pretendard.regular(13)
            label.textColor = Gray.medium
        }
        locationButton.setTitle("\(country) \(city)", for: .normal)
        viewModel.getNFTbyLocation(city)
    }
}
