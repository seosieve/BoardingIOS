//
//  PlanDetailCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/05.
//

import UIKit

class PlanDetailCollectionViewCell: UICollectionViewCell {
    
    var numberLabel = UILabel().then {
        $0.backgroundColor = Boarding.blue
        $0.text = "1"
        $0.font = Pretendard.medium(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
    }
    
    var dashedLineView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 1, height: 94)
    }
    
    var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.image = UIImage(named: "France8")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var titleLabel = UILabel().then {
        $0.text = "에펠탑 노을"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var locationLabel = UILabel().then {
        $0.text = "30141 프랑스도시 프랑스"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.light
    }
    
    var contentLabel = UILabel().then {
        $0.text = "에펠탑에서 노을을 봤는데 완전 환상적이었다. 하늘의 색깔과 도시 불빛이 조화롭게 어우러져서 잊을 수 없는 경험이었다."
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.dark
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
        let attString = NSMutableAttributedString(string: $0.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        attString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attString.length))
        $0.attributedText = attString
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
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.width.equalTo(20)
        }
        numberLabel.rounded(axis: .horizontal)
        
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.top)
            make.left.equalTo(numberLabel.snp.right).offset(8)
            make.width.equalTo(90)
            make.height.equalTo(120)
        }
        
        contentView.addSubview(dashedLineView)
        dashedLineView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.bottom).offset(6)
            make.centerX.equalTo(numberLabel)
        }
        dashedLineView.makeDashLine()
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.top).offset(4)
            make.left.equalTo(photoView.snp.right).offset(8)
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(locationLabel)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(photoView)
        }
    }
}
