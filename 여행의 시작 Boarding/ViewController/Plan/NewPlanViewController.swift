//
//  NewPlanViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit
import RxSwift
import RxCocoa

class NewPlanViewController: UIViewController {
    
    var byHomeVC = false
    
    var titleResult = BehaviorRelay<String>(value: Plan.placeHolder[0])
    var locationResult = BehaviorRelay<String>(value: Plan.placeHolder[1])
    var boardingResult = BehaviorRelay<String>(value: Plan.placeHolder[2])
    var landingResult = BehaviorRelay<String>(value: Plan.placeHolder[3])
    var daysResult = BehaviorRelay<Int>(value: 1)
    var writtenDateResult = BehaviorRelay<Double>(value: 0)
    
    let viewModel = NewPlanViewModel()
    let disposeBag = DisposeBag()
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        if byHomeVC {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    var newTravelLabel = UILabel().then {
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
        let vc = NewPlanTitleViewController()
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
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = byHomeVC ? false : true
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
        
        view.addSubview(newTravelLabel)
        newTravelLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newTravelLabel.snp.bottom).offset(35)
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
            make.top.equalTo(newTravelLabel.snp.bottom).offset(35)
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
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        titleResult
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        titleResult
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        locationResult
            .bind(to: locationLabel.rx.text)
            .disposed(by: disposeBag)
        
        locationResult
            .bind(to: viewModel.location)
            .disposed(by: disposeBag)
        
        boardingResult
            .bind(to: boardingLabel.rx.text)
            .disposed(by: disposeBag)
        
        boardingResult
            .bind(to: viewModel.boarding)
            .disposed(by: disposeBag)
        
        landingResult
            .bind(to: landingLabel.rx.text)
            .disposed(by: disposeBag)
        
        landingResult
            .bind(to: viewModel.landing)
            .disposed(by: disposeBag)
        
        daysResult
            .bind(to: viewModel.days)
            .disposed(by: disposeBag)
        
        writtenDateResult
            .bind(to: viewModel.writtenDate)
            .disposed(by: disposeBag)
        
        viewModel.dataValid
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.completeButton.isEnabled = false
                self?.indicator.startAnimating()
                self?.viewModel.planWrite()
            })
            .disposed(by: disposeBag)
        
        viewModel.writtingResult
            .subscribe(onNext:{ [weak self] result in
                if result {
                    self?.indicator.stopAnimating()
                    if self!.byHomeVC {
                        self?.dismiss(animated: true)
                    } else {
                        self?.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self?.indicator.stopAnimating()
                    self?.writtingErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func writtingErrorAlert() {
        let alert = UIAlertController(title: "글 저장 중 에러가 발생했어요.", message: "다시 시도해주세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        confirm.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}
