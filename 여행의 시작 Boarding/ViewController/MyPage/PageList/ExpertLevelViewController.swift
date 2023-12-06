//
//  ExpertLevelViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import RxSwift
import RxCocoa

class ExpertLevelViewController: UIViewController {
    
    let tag = 2
    let modalClosed = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var expertLevelScrollView = UIScrollView()
    
    var expertLevelContentView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
//    var localGuideView = UIView().then {
//        $0.backgroundColor = Gray.white
//        $0.layer.cornerRadius = 20
//    }
    
    var travelLevelView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var travelLevelLabel = UILabel().then {
        $0.text = "트레블 레벨"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.bright
        expertLevelScrollView.delegate = self
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(expertLevelScrollView)
        expertLevelScrollView.addSubview(expertLevelContentView)
        expertLevelScrollView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        expertLevelContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        expertLevelContentView.addSubview(travelLevelView)
        travelLevelView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        travelLevelView.addSubview(travelLevelLabel)
        travelLevelLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        let levelOne = makeTravelStackView(0,2)
        travelLevelView.addSubview(levelOne)
        levelOne.snp.makeConstraints { make in
            make.top.equalTo(travelLevelLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(135)
        }
        
        let levelTwo = makeTravelStackView(3,5)
        travelLevelView.addSubview(levelTwo)
        levelTwo.snp.makeConstraints { make in
            make.top.equalTo(levelOne.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(135)
        }
        
        let levelThree = makeTravelStackView(6,8)
        travelLevelView.addSubview(levelThree)
        levelThree.snp.makeConstraints { make in
            make.top.equalTo(levelTwo.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(135)
        }
    }
    
    func makeTravelStackView(_ start: Int, _ end: Int) -> UIStackView {
        let travelStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.spacing = 8
        }
        
        for index in start...end {
            let subview = UIView().then {
                $0.backgroundColor = Gray.bright
                $0.layer.cornerRadius = 12
            }
            
            let categoryImage = UIImageView().then {
                $0.image = CategoryInfo.image[index]
            }
            
            let titleLabel = UILabel().then {
                $0.text = CategoryInfo.name[index]
                $0.font = Pretendard.semiBold(17)
                $0.textColor = Gray.black
            }
            
            let levelLabel = UILabel().then {
                $0.text = "Lv.1 (0%)"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.medium
            }
            
            subview.addSubview(categoryImage)
            categoryImage.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(64)
            }
            subview.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalTo(categoryImage.snp.bottom)
                make.centerX.equalToSuperview()
            }
            subview.addSubview(levelLabel)
            levelLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-20)
                make.centerX.equalToSuperview()
            }
            travelStackView.addArrangedSubview(subview)
        }
        return travelStackView
    }
    
    func setRx() {
        modalClosed.subscribe(onNext: { isClosed in
            if isClosed {
                self.expertLevelScrollView.isScrollEnabled = false
            } else {
                self.expertLevelScrollView.isScrollEnabled = true
            }
        })
        .disposed(by: disposeBag)
    }
}

//MARK: - UIScrollView
extension ExpertLevelViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.isScrollEnabled = false
        }
    }
}
