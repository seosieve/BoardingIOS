//
//  SplashViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/27.
//

import UIKit
import RxSwift
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

//Protocol을 통해서 ViewController 구성 통일화
protocol BaseAttribute {
    func setAttribute()
    func setViews()
    func setRx()
}

class SplashViewController: UIViewController {
    
    private let viewModel = SplashViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "TitleWhite")
    }
    
    private var subLabel = UILabel().then {
        $0.text = "새로운 여행의 시작"
        $0.textColor = Gray.white.withAlphaComponent(0.8)
        $0.font = Pretendard.medium(14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        setViews()
        setRx()
        viewModel.aa()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkCurrentUser()
    }
}

extension SplashViewController: BaseAttribute {
    func setViews() {
        view.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(18)
            make.centerY.equalToSuperview().multipliedBy(4.0/5.0)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleImageView.snp.bottom).offset(3)
        }
    }
    
    func setAttribute() {
        view.gradient([Boarding.skyBlue, Boarding.blue], axis: .horizontal)
    }
    
    func setRx() {
        viewModel.isUserLoggedIn
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { loggedIn in
                print(loggedIn)
                let homeVC = TabBarViewController()
                let startVC = ChangableNavigationController(rootViewController: StartViewController())
                let vc = loggedIn ? homeVC : startVC
                self.presentVC(vc, transition: .crossDissolve)
            })
            .disposed(by: disposeBag)
        
        viewModel.checkCurrentUser()
    }
}



