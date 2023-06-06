//
//  PlaceCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/04.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    var placeImageView = UIImageView().then {
        $0.image = UIImage(named: "France1")
    }
    
    var placeTextView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        $0.gradient([Gray.white.withAlphaComponent(0), Gray.black], axis: .vertical)
    }
    
    lazy var placeStarStackView = UIStackView(arrangedSubviews: [star1, star2, star3, star4, star5]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 2
    }
    
    var star1 = UIImageView()
    var star2 = UIImageView()
    var star3 = UIImageView()
    var star4 = UIImageView()
    var star5 = UIImageView()
    
    var placeScore = UILabel().then {
        $0.text = "5.0"
        $0.font = Pretendard.regular(14)
        $0.textColor = Gray.white
    }
    
    var placeLabel = UILabel().then {
        $0.text = "에펠탑"
        $0.font = Pretendard.medium(16)
        $0.textColor = Gray.white
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
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
        contentView.addSubview(placeImageView)
        placeImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(placeTextView)
        placeTextView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        placeTextView.addSubview(placeStarStackView)
        placeStarStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(30)
            make.width.equalTo(72)
        }
        
        placeTextView.addSubview(placeScore)
        placeScore.snp.makeConstraints { make in
            make.left.equalTo(placeStarStackView.snp.right).offset(12)
            make.centerY.equalTo(placeStarStackView)
        }
        
        placeTextView.addSubview(placeLabel)
        placeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
            .inset(6)
        }
    }
}
