//
//  PlanDetailViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/12.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps
import FirebaseStorageUI

class PlanDetailViewController: UIViewController {

    var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var plan = Plan.dummyType
    var selectedDay = 1
    
    lazy var viewModel = PlanDetailViewModel(scrap: plan.scrap)
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
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var modifyButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = Pretendard.regular(17)
        $0.setTitleColor(Gray.medium, for: .normal)
    }
    
    var detailScrollView = UIScrollView()
    
    var detailContentView = UIView()
    
    lazy var titleLabel = UILabel().then {
        $0.text = plan.title
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(25)
    }
    
    lazy var DdayLabel = UILabel().then {
        $0.text = makeDday(boardingDate: plan.boarding)
        $0.font = Pretendard.bold(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
    }
    
    lazy var subTitleLabel = UILabel().then {
        $0.text = "\(plan.location), \(plan.boarding) ~ \(plan.landing)"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.semiLight
    }
    
    var dayScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentOffset = CGPoint(x: -20, y: 0)
    }
    
    var dayStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    @objc func daySelected(_ sender: UIButton) {
        dayStackView.arrangedSubviews.forEach { button in
            if let button = button as? UIButton {
                button.isSelected = false
                button.layer.borderWidth = 1
            }
        }
        
        sender.isSelected = true
        sender.layer.borderWidth = 0
        selectedDay = sender.tag + 1
        feedbackGenerator?.impactOccurred()
        dayLabel.text = "Day \(sender.tag)"
    }
    
    lazy var camera = GMSCameraPosition.camera(withLatitude: 64, longitude: -113, zoom: 14.0)
    
    lazy var map = GMSMapView().then {
        $0.frame = CGRect.zero
        $0.camera = camera
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    var planBackgroundView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var dayView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var dayLabel = UILabel().then {
        $0.text = "Day 1"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var planView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var planPlaceHolder = UILabel().then {
        $0.text = "일정을 추가해 주세요."
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    var planTableView = UITableView().then {
        $0.backgroundColor = Gray.white
        $0.separatorStyle = .none
        $0.isHidden = true
    }
    
    lazy var modalView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 24
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        $0.layer.shadowOffset = CGSize(width:0, height:-3)
        $0.layer.shadowRadius = 10
        $0.layer.shadowColor = Gray.black.cgColor
        $0.layer.shadowOpacity = 0.1
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panModalMotion))
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapModalMotion))
        $0.addGestureRecognizer(pan)
        $0.addGestureRecognizer(tap)
    }
    
    @objc func panModalMotion(_ recognizer: UIPanGestureRecognizer) {
        let minY:CGFloat = 0
        let maxY:CGFloat = 210
        
        switch recognizer.state {
        case .began, .changed:
            let translation = recognizer.translation(in: modalView)
            let y = min(maxY, max(minY, modalView.frame.maxY - 844 + translation.y))
    
            modalView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(y)
            }
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
        case .ended:
            let velocity = recognizer.velocity(in: modalView).y
            let shouldClose = velocity > 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.modalView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(shouldClose ? maxY : minY)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        default:
            break
        }
    }
    
    @objc func tapModalMotion(_ recognizer: UIPanGestureRecognizer) {
        if modalView.frame.maxY == 1054 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.modalView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(0)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func scrapStackViewSelected(_ sender: UITapGestureRecognizer) {
        if modalView.frame.maxY == 844 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.modalView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview().offset(210)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        planTableView.isHidden = false
        planPlaceHolder.isHidden = true
    }
    
    var modalIndicator = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var scrapLabel = UILabel().then {
        $0.text = "나의 스크랩"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var scrapScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentOffset = CGPoint(x: -20, y: 0)
    }
    
    var scrapStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Gray.white
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        detailScrollView.delegate = self
        planTableView.register(PlanDetailTableViewCell.self, forCellReuseIdentifier: "planDetailTableViewCell")
        planTableView.delegate = self
        planTableView.dataSource = self
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
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(modifyButton)
        modifyButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-20)
        }
        
        view.insertSubview(detailScrollView, belowSubview: iconView)
        detailScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(iconView.snp.bottom)
        }
        
        detailScrollView.addSubview(detailContentView)
        detailContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        detailContentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
        }
        
        detailContentView.addSubview(DdayLabel)
        DdayLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        DdayLabel.rounded(axis: .horizontal)
        DdayLabel.backgroundColor = DdayLabel.text!.count > 3 ? Gray.light : Boarding.red
        
        detailContentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }
        
        detailContentView.addSubview(dayScrollView)
        dayScrollView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(25)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        dayScrollView.addSubview(dayStackView)
        dayStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        for index in 0..<plan.days {
            let dayButton = UIButton().then {
                $0.tag = index
                $0.setBackgroundColor(Gray.white, for: .normal)
                $0.setBackgroundColor(Boarding.blue, for: .selected)
                $0.setTitle("Day \(index+1)", for: .normal)
                $0.setTitleColor(Gray.medium, for: .normal)
                $0.setTitleColor(Gray.white, for: .selected)
                $0.titleLabel?.font = Pretendard.medium(15)
                $0.layer.borderColor = Gray.bright.cgColor
                $0.layer.borderWidth = 1
                $0.addTarget(self, action: #selector(daySelected), for: .touchUpInside)
            }
            if index == 0 {
                dayButton.isSelected = true
                dayButton.layer.borderWidth = 0
            }
            dayStackView.addArrangedSubview(dayButton)
            dayButton.snp.makeConstraints { make in
                make.width.equalTo(64)
                make.height.equalTo(32)
            }
            dayButton.rounded(axis: .horizontal)
        }
        
        detailContentView.addSubview(map)
        map.snp.makeConstraints { make in
            make.top.equalTo(dayScrollView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalTo(subTitleLabel)
            make.height.equalTo(230)
        }
        
        detailContentView.addSubview(planBackgroundView)
        planBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(map.snp.bottom).offset(20)
            make.centerX.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        planBackgroundView.addSubview(dayView)
        dayView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(65)
        }
        
        dayView.addSubview(dayLabel)
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        planBackgroundView.addSubview(planView)
        planView.snp.makeConstraints { make in
            make.top.equalTo(dayView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        
        planView.addSubview(planPlaceHolder)
        planPlaceHolder.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        planView.addSubview(planTableView)
        planTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(120)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(210)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(290)
        }
        
        modalView.addSubview(modalIndicator)
        modalIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        modalIndicator.rounded(axis: .horizontal)
        
        modalView.addSubview(scrapLabel)
        scrapLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(scrapScrollView)
        scrapScrollView.snp.makeConstraints { make in
            make.top.equalTo(scrapLabel.snp.bottom).offset(30)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(150)
        }
        
        scrapScrollView.addSubview(scrapStackView)
        scrapStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func setRx() {
        modifyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.popUpAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .subscribe(onNext: { [weak self] NFTArr in
                self?.makeStackView(NFTArr)
            })
            .disposed(by: disposeBag)
    }
    
    func makeStackView(_ NFTArr: [NFT]) {
        scrapStackView.removeAllArrangedSubviews()
        for index in 0..<NFTArr.count {
            let subview = UIView().then {
                $0.layer.cornerRadius = 8
                $0.layer.masksToBounds = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(scrapStackViewSelected(_:)))
                tap.cancelsTouchesInView = false
                $0.addGestureRecognizer(tap)
            }
            
            let photoView = UIImageView().then {
                $0.image = UIImage(named: "France1")
                $0.layer.cornerRadius = 8
                $0.clipsToBounds = true
            }
            
            let gradientView = UIView().then {
                $0.frame = CGRect(x: 0, y: 0, width: 113, height: 100)
                $0.gradient([Gray.black.withAlphaComponent(0), .black], axis: .vertical)
            }
            
            let titleLabel = UILabel().then {
                $0.text = NFTArr[index].title
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.white
            }
            
            let plusImageView = UIImageView().then {
                $0.image = UIImage(named: "SmallPlus")
            }
            
            subview.snp.makeConstraints { make in
                make.width.equalTo(113)
            }
            subview.addSubview(photoView)
            photoView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            photoView.sd_setImage(with: URL(string: NFTArr[index].url), placeholderImage: nil, options: .scaleDownLargeImages)
            subview.addSubview(gradientView)
            gradientView.snp.makeConstraints { make in
                make.left.centerX.bottom.equalToSuperview()
                make.height.equalTo(100)
            }
            subview.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(6)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-14)
            }
            subview.addSubview(plusImageView)
            plusImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(6)
                make.right.equalToSuperview().offset(-6)
                make.width.height.equalTo(24)
            }
            scrapStackView.addArrangedSubview(subview)
        }
    }
    
    func popUpAlert() {
        let alert = UIAlertController(title: "정말로 삭제하시겠어요?", message: "한 번 삭제한 플랜은 되돌릴 수 없어요", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "삭제", style: .default) { action in
//            self.indicator.startAnimating()
//            self.view.isUserInteractionEnabled = false
//            self.viewModel.NFTDelete(NFTID: self.NFTResult.NFTID)
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(UIColor.red, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDelegate
extension PlanDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "planDetailTableViewCell", for: indexPath) as! PlanDetailTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

//MARK: - UIScrollView
extension PlanDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var level = scrollView.contentOffset.y
        level = max(0, level)
        level = min(100, level)
        iconView.layer.shadowOpacity = Float(level/2000)
    }
}
