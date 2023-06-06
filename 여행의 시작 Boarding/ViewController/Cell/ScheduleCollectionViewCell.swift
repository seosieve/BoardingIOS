//
//  ScheduleCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/05.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    var borderView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.light.cgColor
    }
    
    var scheduleImageView = UIImageView().then {
        $0.image = UIImage(named: "France8")
    }
    
    var scheduleTitleLabel = UILabel().then {
        $0.text = "파리 4박 여행"
        $0.font = Pretendard.medium(16)
        $0.textColor = Gray.dark
    }
    
    var scheduleSubLabel = UILabel().then {
        $0.text = "파리, 프랑스"
        $0.font = Pretendard.regular(10)
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
            make.height.equalTo(215)
        }
        borderView.rounded(axis: .vertical)
        
        borderView.addSubview(scheduleImageView)
        scheduleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(7.5)
        }
        scheduleImageView.rounded(axis: .vertical)
        
        contentView.addSubview(scheduleTitleLabel)
        scheduleTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(borderView.snp.bottom).offset(6)
        }
        
        contentView.addSubview(scheduleSubLabel)
        scheduleSubLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(scheduleTitleLabel.snp.bottom).offset(4)
        }
    }
}
