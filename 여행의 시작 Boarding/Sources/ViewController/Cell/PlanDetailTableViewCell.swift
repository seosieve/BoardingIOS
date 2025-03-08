//
//  PlanDetailTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/05.
//

import UIKit

class PlanDetailTableViewCell: UITableViewCell {
    var numberLabel = UILabel().then {
        $0.backgroundColor = Boarding.blue
        $0.text = "1"
        $0.font = Pretendard.medium(13)
        $0.textColor = Gray.white
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var dashedLineView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 1, height: 94)
    }
    
    var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var locationLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.light
    }
    
    var contentLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.dark
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    var memoView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 12
    }
    
    var memoLabel = UILabel().then {
        $0.text = "버스 오른쪽에 앉아서 버스 창문 너머로 펼쳐지는 해안 도로의 아름다운 경치 감상하기"
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.dark
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0))
    }
    
    func setViews() {
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(numberLabel.snp.top)
            make.left.equalTo(numberLabel.snp.right).offset(8)
            make.width.equalTo(90)
            make.height.equalTo(120)
        }
        photoView.loadingAnimation()
        
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
            make.right.equalToSuperview()
        }
        
        contentView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview()
            make.height.equalTo(20)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.left.equalTo(locationLabel)
            make.right.equalToSuperview()
            make.bottom.lessThanOrEqualTo(photoView)
        }
        
        contentView.addSubview(memoView)
        memoView.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(20)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
        
        memoView.addSubview(memoLabel)
        memoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
}
