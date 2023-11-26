//
//  NFTCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/04.
//

import UIKit

class NFTCollectionViewCell: UICollectionViewCell {
    
    var NFTImageView = UIImageView().then {
        $0.image = UIImage()
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
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
        contentView.addSubview(NFTImageView)
        NFTImageView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        NFTImageView.loadingAnimation()
    }
}
