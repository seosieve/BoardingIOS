//
//  PastTravelViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/13.
//

import UIKit
import RxSwift
import RxCocoa

class PastTravelViewController: UIViewController {

    var dismiss = true
    
    let viewModel = NewPlanViewModel()
    let disposeBag = DisposeBag()
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var pastTravelLabel = UILabel().then {
        $0.text = "지난 여행 만들기"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var titleLabel = UILabel().then {
        $0.text = "여행제목"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    var locationLabel = UILabel().then {
        $0.text = "여행지"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    var durationLabel = UILabel().then {
        $0.text = "여행 기간"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    lazy var tapRecognizerView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized() {
        let vc = PastTravelTitleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var completeButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.isEnabled = false
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(pastTravelLabel)
        pastTravelLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pastTravelLabel.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(20)
        }

        let titleDivider = divider()
        view.addSubview(titleDivider)
        titleDivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }

        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleDivider.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
        }

        let locationDivider = divider()
        view.addSubview(locationDivider)
        locationDivider.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }

        view.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.top.equalTo(locationDivider.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
        }

        let durationDivider = divider()
        view.addSubview(durationDivider)
        durationDivider.snp.makeConstraints { make in
            make.top.equalTo(durationLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
        
        view.addSubview(tapRecognizerView)
        tapRecognizerView.snp.makeConstraints { make in
            make.top.equalTo(pastTravelLabel.snp.bottom).offset(35)
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(durationDivider.snp.bottom)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        completeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                print("aa")
            })
            .disposed(by: disposeBag)
    }
}
