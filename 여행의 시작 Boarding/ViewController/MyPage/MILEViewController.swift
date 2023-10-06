//
//  MILEViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class MILEViewController: UIViewController {

    let tag = 1
    let modalClosed = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var MILEScrollView = UIScrollView()
    
    var MILEContentView = UIView()
    
    var myAssetView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var calculatePlanView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var calculateHistoryView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var byRecordView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.bright
        MILEScrollView.delegate = self
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(MILEScrollView)
        MILEScrollView.addSubview(MILEContentView)
        MILEScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        MILEContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        MILEContentView.addSubview(myAssetView)
        myAssetView.snp.makeConstraints { make in
            make.top.centerX.left.equalToSuperview()
            make.height.equalTo(290)
        }
        
        MILEContentView.addSubview(calculatePlanView)
        calculatePlanView.snp.makeConstraints { make in
            make.top.equalTo(myAssetView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(145)
        }
        
        MILEContentView.addSubview(calculateHistoryView)
        calculateHistoryView.snp.makeConstraints { make in
            make.top.equalTo(calculatePlanView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(520)
        }
        
        MILEContentView.addSubview(byRecordView)
        byRecordView.snp.makeConstraints { make in
            make.top.equalTo(calculateHistoryView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(-200)
        }
    }
    
    func setRx() {
        modalClosed.subscribe(onNext: { isClosed in
            if isClosed {
                self.MILEScrollView.isScrollEnabled = false
            } else {
                self.MILEScrollView.isScrollEnabled = true
            }
        })
        .disposed(by: disposeBag)
    }
}

//MARK: - UIScrollView
extension MILEViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.isScrollEnabled = false
        }
    }
}
