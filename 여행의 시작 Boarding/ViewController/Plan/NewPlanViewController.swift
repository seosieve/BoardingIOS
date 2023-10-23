//
//  NewPlanViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit
import Then
import SnapKit

class NewPlanViewController: UIViewController {

    var dismiss = true
    
    var pastTravelLabel = UILabel().then {
        $0.text = "새로운 여행 생성"
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
    
    var boardingLabel = UILabel().then {
        $0.text = "가는 날"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    var landingLabel = UILabel().then {
        $0.text = "오는 날"
        $0.font = Pretendard.regular(21)
        $0.textColor = Gray.light
    }
    
    lazy var tapRecognizerView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized() {
        dismiss = false
        let vc = NewPlanTitleViewController()
        vc.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var completeButton = UIButton().then {
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        print("aa")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setNavigationBar()
        self.navigationController?.navigationBar.tintColor = Gray.medium
        view.backgroundColor = Gray.white
        setViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if dismiss {
            self.navigationController?.navigationBar.isHidden = true
        }
        dismiss.toggle()
    }
    
    func setViews() {
        view.addSubview(pastTravelLabel)
        pastTravelLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom()+20)
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

        view.addSubview(boardingLabel)
        boardingLabel.snp.makeConstraints { make in
            make.top.equalTo(locationDivider.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
        }
        
        let boardingDivider = divider()
        view.addSubview(boardingDivider)
        boardingDivider.snp.makeConstraints { make in
            make.top.equalTo(boardingLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(view.snp.centerX).offset(-15)
            make.height.equalTo(1)
        }

        view.addSubview(landingLabel)
        landingLabel.snp.makeConstraints { make in
            make.top.equalTo(locationDivider.snp.bottom).offset(40)
            make.left.equalTo(view.snp.centerX).offset(10)
        }

        let landingDivider = divider()
        view.addSubview(landingDivider)
        landingDivider.snp.makeConstraints { make in
            make.top.equalTo(boardingLabel.snp.bottom).offset(12)
            make.left.equalTo(view.snp.centerX).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(1)
        }
        
        view.addSubview(tapRecognizerView)
        tapRecognizerView.snp.makeConstraints { make in
            make.top.equalTo(pastTravelLabel.snp.bottom).offset(35)
            make.left.centerX.equalToSuperview()
            make.bottom.equalTo(boardingDivider.snp.bottom)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
    }
}
