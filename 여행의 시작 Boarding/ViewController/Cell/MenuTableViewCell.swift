//
//  MenuTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    var menuLabel = UILabel().then {
        $0.text = "내 NFT"
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.dark
    }
    
    var detailButton = UIButton().then {
        $0.setImage(UIImage(named: "Detail"), for: .normal)
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
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.isSelected = false
            }
        }
    }
    
    func setViews() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(24)
        }
    }
}
