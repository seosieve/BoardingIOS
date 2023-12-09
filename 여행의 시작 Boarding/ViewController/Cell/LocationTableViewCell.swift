//
//  LocationTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/22.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    var cellTapped: (() -> Void)?
    var iconTapped: ((UIButton) -> Void)?
    
    var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    lazy var subLabel = UILabel().then {
        $0.text = "최근 게시물 0개"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    lazy var bookMarkButton = UIButton().then {
        $0.setImage(UIImage(named: "BookMark"), for: .normal)
        $0.setImage(UIImage(named: "BookMarkFilled"), for: .selected)
        $0.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func favoriteButtonPressed(_ sender: UIButton) {
        iconTapped?(sender)
    }
    
    @objc func contentViewPressed(_ sender: UIButton) {
        cellTapped?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(contentViewPressed))
        contentView.addGestureRecognizer(tap)
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

    func setViews() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.equalTo(photoView.snp.right).offset(12)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
        }
        
        contentView.addSubview(bookMarkButton)
        bookMarkButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoView)
            make.right.equalToSuperview().offset(-8)
            make.width.height.equalTo(34)
        }
    }
}
