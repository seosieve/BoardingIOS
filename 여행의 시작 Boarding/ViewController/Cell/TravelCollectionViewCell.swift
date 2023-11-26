//
//  TravelCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/05.
//

import UIKit

class TravelCollectionViewCell: UICollectionViewCell {
    
    var borderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.semiLight.cgColor
    }
    
    var travelImageView = UIImageView().then {
        $0.image = UIImage(named: "France8")
    }
    
    var mainLabel = UILabel().then {
        $0.text = "파리 4박 여행"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var subLabel = UILabel().then {
        $0.text = "파리, 프랑스"
        $0.font = Pretendard.regular(13)
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
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(210)
        }
        borderView.rounded(axis: .vertical, mask: false)
        borderView.makeShadow(opacity: 0.2, shadowRadius: 5)
        
        borderView.addSubview(travelImageView)
        travelImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        travelImageView.rounded(axis: .vertical)
        
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(borderView.snp.bottom).offset(12)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
        }
    }
}
