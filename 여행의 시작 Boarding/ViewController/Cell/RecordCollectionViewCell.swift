//
//  RecordCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    var recordImageView = UIImageView().then {
        $0.image = UIImage(named: "France1")
    }
    
    var recordTextView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 120, height: 36)
        $0.gradient([Gray.white.withAlphaComponent(0), Gray.black], axis: .vertical)
    }
    
    var recordLabel = UILabel().then {
        $0.text = "에펠탑"
        $0.font = Pretendard.regular(14)
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
        contentView.addSubview(recordImageView)
        recordImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.addSubview(recordTextView)
        recordTextView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
            make.height.equalTo(36)
        }
        
        recordTextView.addSubview(recordLabel)
        recordLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
            .inset(9)
        }
    }
}
