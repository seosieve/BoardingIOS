//
//  PlanCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit
import RxSwift
import RxCocoa

class PlanCollectionViewCell: UICollectionViewCell {
    
    var photoTapped: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    var borderView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var travelImageView = UIImageView().then {
        $0.backgroundColor = Gray.semiLight.withAlphaComponent(0.6)
        $0.contentMode = .scaleAspectFill
    }
    
    var placeHolderView = UIView()
    
    var placeHolderImage = UIImageView().then {
        $0.image = UIImage(named: "TitleWhite")
    }
    
    var placeHolderLabel = UILabel().then {
        $0.text = "여행 일정 추가하기"
        $0.font = Pretendard.semiBold(16)
        $0.textColor = Gray.white
    }
    
    lazy var planDetailButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    var mainTextView = UIView()
    
    var mainLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var DdayLabel = UILabel().then {
        $0.backgroundColor = Boarding.red
        $0.text = ""
        $0.font = Pretendard.semiBold(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
    }
    
    var durationLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    var locationLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setViews() {
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
        borderView.rounded(axis: .vertical, mask: false)
        borderView.makeShadow(opacity: 0.3, shadowRadius: 10)
        
        borderView.addSubview(travelImageView)
        travelImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        travelImageView.rounded(axis: .vertical)
        
        borderView.addSubview(placeHolderView)
        placeHolderView.snp.makeConstraints { make in
            make.left.centerX.centerY.equalToSuperview()
        }
        
        placeHolderView.addSubview(placeHolderImage)
        placeHolderImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(60)
            make.width.equalTo(210)
            make.height.equalTo(55)
        }
        
        placeHolderView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.top.equalTo(placeHolderImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        borderView.addSubview(planDetailButton)
        planDetailButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        planDetailButton.rounded(axis: .vertical)
        
        contentView.addSubview(mainTextView)
        mainTextView.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(35)
        }
        
        mainTextView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
        }
        
        mainTextView.addSubview(DdayLabel)
        DdayLabel.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right).offset(6)
            make.right.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        DdayLabel.rounded(axis: .horizontal)
        
        contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTextView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(durationLabel.snp.bottom).offset(6)
        }
    }
    
    func setRx() {
        planDetailButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.photoTapped?()
            })
            .disposed(by: disposeBag)
    }
}
