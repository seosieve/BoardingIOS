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

class SplashViewController: UIViewController {
    //강하게 결합 - viewModel(하위모듈)
    let viewModel = SplashViewModel()
    let disposeBag = DisposeBag()
    
    var titleImageView = UIImageView().then {
        $0.image = UIImage(named: "TitleWhite")
    }
    
    var subLabel = UILabel().then {
        $0.text = "새로운 여행의 시작"
        $0.textColor = Gray.white.withAlphaComponent(0.8)
        $0.font = Pretendard.medium(14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.gradient([Boarding.skyBlue, Boarding.blue], axis: .horizontal)
        setViews()
        setRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkCurrentUser()
    }
    
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
    
    func setRx() {
        viewModel.isUserLoggedIn
            .debug("🩷")
            .subscribe(onNext:{ [weak self] loggedIn in
//                let homeVC = TabBarViewController()
//                let startVC = ChangableNavigationController(rootViewController: StartViewController())
//                let vc = loggedIn ? homeVC : startVC
//                self?.presentVC(vc, transition: .crossDissolve)
            })
            .disposed(by: disposeBag)
        
//        viewModel.isUserLoggedIn
//            .subscribe { [weak self] loggedIn in
//                print("😃", loggedIn)
//            }
//            .disposed(by: disposeBag)
        
        print("aa")
        Task {
            do {
                print("bb")
                for try await loggedIn in viewModel.isUserLoggedIn.asObservable().values {
                    print("cc")
                    let homeVC = TabBarViewController()
                    let startVC = ChangableNavigationController(rootViewController: StartViewController())
                    let vc = loggedIn ? homeVC : startVC
                    presentVC(vc, transition: .crossDissolve)
                }
            } catch {
                print("dd")
            }
            
        }
    }
}
