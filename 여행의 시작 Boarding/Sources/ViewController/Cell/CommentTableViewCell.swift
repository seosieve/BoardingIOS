//
//  CommentTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/14/23.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var likeTapped: (() -> Void)?
    
    var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    var userNameLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var commentTimeLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    var commentLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.black
        $0.numberOfLines = 2
        $0.lineBreakMode = .byCharWrapping
    }
    
    var commentLikeCount = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    lazy var commentLikeButton = UIButton().then {
        $0.setImage(UIImage(named: "Like"), for: .normal)
        $0.setImage(UIImage(named: "LikeFilled"), for: .selected)
        $0.addTarget(self, action: #selector(commentLikeButtonPressed), for: .touchUpInside)
    }
    
    @objc func commentLikeButtonPressed() {
        likeTapped?()
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

    func setViews() {
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(32)
        }
        photoView.loadingAnimation()
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoView)
            make.left.equalTo(photoView.snp.right).offset(12)
        }
        
        contentView.addSubview(commentTimeLabel)
        commentTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(userNameLabel.snp.right).offset(6)
            make.bottom.equalTo(userNameLabel)
        }
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom).offset(8)
            make.left.equalTo(userNameLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        contentView.addSubview(commentLikeCount)
        commentLikeCount.snp.makeConstraints { make in
            make.top.equalTo(commentLabel.snp.bottom).offset(8)
            make.left.equalTo(commentLabel)
        }
        
        contentView.addSubview(commentLikeButton)
        commentLikeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(commentLikeCount)
            make.width.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func isUserAlreadyLiked(userUid: String, likedPeople: [String]) {
        commentLikeButton.isSelected = likedPeople.contains(userUid) ? true : false
    }
}
