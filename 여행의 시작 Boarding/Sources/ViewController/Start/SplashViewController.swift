//
//  SplashViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/27.
//

import UIKit
import RxSwift

final class SplashViewController: UIViewController {
    
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
        setViews()
        setRx()
    }
    
    // View가 생성된 이후에 화면전환이 가능하므로 viewDidAppear에서 함수 호출
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.checkUserLoggedIn()
    }
    
    func setViews() {
        view.gradient([Boarding.skyBlue, Boarding.blue], axis: .horizontal)
        
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
            .bind(with: self) { owner, loggedIn in
                owner.setInitialViewController(loggedIn)
            }
            .disposed(by: disposeBag)
    }
    
    func setInitialViewController(_ loggedIn: Bool) {
        ///User Exists
        let homeVC = TabBarViewController()
        ///User Not Exists
        let startVC = ChangableNavigationController(rootViewController: StartViewController())
        let vc = loggedIn ? homeVC : startVC
        self.presentVC(vc, transition: .crossDissolve)
    }
}



