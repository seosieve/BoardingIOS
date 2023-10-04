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
            make.height.equalTo(450)
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
