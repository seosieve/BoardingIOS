//
//  NFTCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/04.
//

import UIKit

class NFTCollectionViewCell: UICollectionViewCell {
    
    var NFTImageView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.image = UIImage()
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
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.NFTImageView.backgroundColor = Gray.white
        })
    }
}
