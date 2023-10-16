//
//  PlanCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/16.
//

import UIKit

class PlanCollectionViewCell: UICollectionViewCell {
    
    var borderView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var travelImageView = UIImageView().then {
        $0.image = UIImage(named: "France8")
    }
    
    var mainTextView = UIView()
    
    var mainLabel = UILabel().then {
        $0.text = "파리 4박 여행"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var DdayLabel = UILabel().then {
        $0.backgroundColor = .magenta
        $0.text = "D-3"
        $0.font = Pretendard.semiBold(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
    }
    
    var travelSubLabel = UILabel().then {
        $0.text = "파리, 프랑스"
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    var locationLabel = UILabel().then {
        $0.text = "유럽 전체"
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.medium
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
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
            make.centerX.equalToSuperview()
            make.top.left.equalToSuperview().offset(20)
            make.height.equalTo(400)
        }
        borderView.rounded(axis: .vertical)
        borderView.makeShadow(shadowRadius: 20)
        
        borderView.addSubview(travelImageView)
        travelImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        travelImageView.rounded(axis: .vertical)
        
        mainTextView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.left.top.centerY.equalToSuperview()
        }
        
        mainTextView.addSubview(DdayLabel)
        DdayLabel.snp.makeConstraints { make in
            make.left.equalTo(mainLabel.snp.right).offset(6)
            make.right.top.centerY.equalToSuperview()
            make.width.equalTo(45)
            make.height.equalTo(26)
        }
        DdayLabel.rounded(axis: .vertical)
        
        contentView.addSubview(mainTextView)
        mainTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(borderView.snp.bottom).offset(20)
        }
        
        contentView.addSubview(travelSubLabel)
        travelSubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTextView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(travelSubLabel.snp.bottom).offset(6)
        }
    }
}
