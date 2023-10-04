//
//  NFTCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/04.
//

import UIKit

class NFTCollectionViewCell: UICollectionViewCell {
    
    var NFTImageView = UIImageView().then {
        $0.image = UIImage(named: "France1")
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
        contentView.addSubview(NFTImageView)
        NFTImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
