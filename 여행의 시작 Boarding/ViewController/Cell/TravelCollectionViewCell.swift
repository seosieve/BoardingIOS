//
//  TravelCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/05.
//

import UIKit

class TravelCollectionViewCell: UICollectionViewCell {
    
    var borderView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.withAlphaComponent(0.6).cgColor
    }
    
    var travelImageView = UIImageView().then {
        $0.image = UIImage(named: "France8")
    }
    
    var travelTitleLabel = UILabel().then {
        $0.text = "파리 4박 여행"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var travelSubLabel = UILabel().then {
        $0.text = "파리, 프랑스"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.light
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
            make.centerX.left.top.equalToSuperview()
            make.height.equalTo(210)
        }
        borderView.rounded(axis: .vertical)
        
        borderView.addSubview(travelImageView)
        travelImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        travelImageView.rounded(axis: .vertical)
        
        contentView.addSubview(travelTitleLabel)
        travelTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(borderView.snp.bottom).offset(10)
        }
        
        contentView.addSubview(travelSubLabel)
        travelSubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(travelTitleLabel.snp.bottom).offset(6)
        }
    }
}
