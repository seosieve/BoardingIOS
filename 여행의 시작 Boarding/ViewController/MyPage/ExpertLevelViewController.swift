//
//  ExpertLevelViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class ExpertLevelViewController: UIViewController {
    
    let tag = 2
    let modalClosed = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var expertLevelScrollView = UIScrollView()
    
    var expertLevelContentView = UIView()
    
    var localGuideView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var expertView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
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
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        expertLevelContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        expertLevelContentView.addSubview(localGuideView)
        localGuideView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(126)
        }
        
        expertLevelContentView.addSubview(expertView)
        expertView.snp.makeConstraints { make in
            make.top.equalTo(localGuideView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(359)
        }
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
