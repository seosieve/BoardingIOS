//
//  MILEViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
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
    
    var myAssetLabel = UILabel().then {
        $0.text = "내 자산"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var MILEImageView = UIImageView().then {
        $0.image = UIImage(named: "MILE")
    }
    
    var MILELabel = UILabel().then {
        $0.text = "200 MILE"
        $0.font = Pretendard.light(21)
        $0.textColor = Gray.black
        let attributedString = NSMutableAttributedString(string: $0.text!)
        attributedString.addAttribute(.font, value: Pretendard.medium(35), range: ($0.text! as NSString).range(of: "200"))
        $0.attributedText = attributedString
    }
    
    var calculatePlanView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var calculatePlanLabel = UILabel().then {
        $0.text = "이번주 정산 예정"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var calculatePlanStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillProportionally
        $0.spacing = 8
    }
    
    var calculateHistoryView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var calculateHistoryLabel = UILabel().then {
        $0.text = "정산 내역"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var calculateHistoryStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 8
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
            make.height.equalTo(230)
        }
        
        myAssetView.addSubview(myAssetLabel)
        myAssetLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        myAssetView.addSubview(MILEImageView)
        MILEImageView.snp.makeConstraints { make in
            make.top.equalTo(myAssetLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(115)
        }
        
        myAssetView.addSubview(MILELabel)
        MILELabel.snp.makeConstraints { make in
            make.centerY.equalTo(MILEImageView)
            make.right.equalToSuperview().offset(-20)
        }
        
        MILEContentView.addSubview(calculatePlanView)
        calculatePlanView.snp.makeConstraints { make in
            make.top.equalTo(myAssetView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(220)
        }
        
        calculatePlanView.addSubview(calculatePlanLabel)
        calculatePlanLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        calculatePlanView.addSubview(calculatePlanStackView)
        calculatePlanStackView.snp.makeConstraints { make in
            make.top.equalTo(calculatePlanLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
        }
        let info = ["좋아요", "스크랩", "신뢰도", "합계"]
        for index in 0..<4 {
            let subview = UIView()
            
            let titleLabel = UILabel().then {
                $0.text = info[index]
                $0.font = Pretendard.regular(14)
                $0.textColor = Gray.medium
            }
            let valueLabel = UILabel().then {
                $0.text = "+ 25"
                $0.font = Pretendard.regular(14)
                $0.textColor = Gray.black
            }
            
            let calculateResultLabel = UILabel().then {
                $0.text = "75 MILE"
                $0.font = Pretendard.light(17)
                $0.textColor = Gray.black
                let attributedString = NSMutableAttributedString(string: $0.text!)
                attributedString.addAttribute(.font, value: Pretendard.medium(27), range: ($0.text! as NSString).range(of: "75"))
                $0.attributedText = attributedString
            }
            
            subview.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
            }
            if index == 3 {
                subview.addSubview(calculateResultLabel)
                calculateResultLabel.snp.makeConstraints { make in
                    make.right.centerY.equalToSuperview()
                    make.top.equalToSuperview().offset(5)
                }
            } else {
                subview.addSubview(valueLabel)
                valueLabel.snp.makeConstraints { make in
                    make.right.top.centerY.equalToSuperview()
                }
            }
            calculatePlanStackView.addArrangedSubview(subview)
        }
        
        let calculateDivider = divider()
        calculatePlanView.addSubview(calculateDivider)
        calculateDivider.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
        
        MILEContentView.addSubview(calculateHistoryView)
        calculateHistoryView.snp.makeConstraints { make in
            make.top.equalTo(calculatePlanView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-200)
        }
        
        calculateHistoryView.addSubview(calculateHistoryLabel)
        calculateHistoryLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        calculateHistoryView.addSubview(calculateHistoryStackView)
        calculateHistoryStackView.snp.makeConstraints { make in
            make.top.equalTo(calculateHistoryLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(230)
        }
        for _ in 0..<3 {
            let subview = UIView().then {
                $0.backgroundColor = Gray.bright
                $0.layer.cornerRadius = 12
            }
            let weekRangeLabel = UILabel().then {
                $0.text = "2023.12.01 ~ 2023.12.08"
                $0.font = Pretendard.regular(14)
                $0.textColor = Gray.medium
            }
            let weekLabel = UILabel().then {
                $0.text = "12월 1주차"
                $0.font = Pretendard.semiBold(17)
                $0.textColor = Gray.black
            }
            let valueLabel = UILabel().then {
                $0.text = "45"
                $0.font = Pretendard.semiBold(17)
                $0.textColor = Gray.black
            }
            
            subview.addSubview(weekRangeLabel)
            weekRangeLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.left.equalToSuperview().offset(20)
            }
            subview.addSubview(weekLabel)
            weekLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.bottom.equalToSuperview().offset(-12)
            }
            subview.addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(weekLabel)
            }
            calculateHistoryStackView.addArrangedSubview(subview)
        }
        
//        MILEContentView.addSubview(byRecordView)
//        byRecordView.snp.makeConstraints { make in
//            make.top.equalTo(calculateHistoryView.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(20)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(400)
//            make.bottom.equalToSuperview().offset(-200)
//        }
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
