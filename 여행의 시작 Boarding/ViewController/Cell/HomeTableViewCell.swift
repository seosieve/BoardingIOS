//
//  HomeTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/05.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var photoTapped: (() -> Void)?
    var iconTapped: ((UIButton) -> Void)?
    
    var userImage = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    var userNameLabel = UILabel().then {
        $0.backgroundColor = Gray.white
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.black
    }
    
    var userAchievementStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 7
    }
    
    var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var contentLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.dark
        $0.numberOfLines = 3
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    lazy var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    lazy var photoContainerButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
        $0.addTarget(self, action: #selector(photoContainerPressed), for: .touchUpInside)
    }
    
    @objc func photoContainerPressed() {
        photoTapped?()
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = Gray.white
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    @objc func iconButtonPressed(_ sender: UIButton) {
        iconTapped?(sender)
    }
    
    var scoreView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 12
    }
    
    var scoreImage = UIImageView().then {
        $0.image = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.medium
    }
    
    var scoreLabel = UILabel().then {
        $0.text = "5.0"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    var locationView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 12
    }
    
    var locationImage = UIImageView().then {
        $0.image = UIImage(named: "Place")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.medium
    }
    
    var locationLabel = UILabel().then {
        $0.text = "Location Label"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        putUserAchievement()
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
        contentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(32)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.left.equalTo(userImage.snp.right).offset(4)
        }
        
        contentView.addSubview(userAchievementStackView)
        userAchievementStackView.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.left.equalTo(userNameLabel.snp.right).offset(8)
            make.width.equalTo(52)
            make.height.equalTo(24)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.lessThanOrEqualTo(72)
        }
        
        contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(77)
            make.height.equalTo(450)
        }
        photoView.loadingAnimation()
        
        contentView.addSubview(photoContainerButton)
        photoContainerButton.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(77)
            make.height.equalTo(450)
        }
        
        contentView.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.left.equalTo(photoView.snp.right).offset(24)
            make.bottom.equalTo(photoView)
            make.width.equalTo(32)
        }
        let icon = [InteractionInfo.report, InteractionInfo.comment, InteractionInfo.like, InteractionInfo.save]
        for index in 0..<icon.count {
            let subview = UIView()
            
            lazy var iconButton = UIButton().then {
                $0.tag = index
                $0.setImage(icon[index].0, for: .normal)
                $0.setImage(icon[index].1, for: .selected)
                $0.addTarget(self, action: #selector(iconButtonPressed(_:)), for: .touchUpInside)
            }
            
            let numberLabel = UILabel().then {
                $0.tag = 1
                $0.text = "0"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.dark
                $0.textAlignment = .center
            }
            
            subview.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            subview.addSubview(iconButton)
            iconButton.snp.makeConstraints { make in
                make.top.left.centerX.equalToSuperview()
                make.height.equalTo(32)
            }
            
            subview.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.top.equalTo(iconButton.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
            }
            interactionStackView.addArrangedSubview(subview)
        }
        
        contentView.addSubview(scoreView)
        scoreView.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        scoreView.addSubview(scoreImage)
        scoreImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(15)
        }
        scoreView.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(scoreImage.snp.right).offset(4)
            make.right.equalToSuperview().inset(8)
        }
        
        contentView.addSubview(locationView)
        locationView.snp.makeConstraints { make in
            make.centerY.equalTo(scoreView)
            make.left.equalTo(scoreView.snp.right).offset(8)
            make.height.equalTo(24)
        }
        locationView.addSubview(locationImage)
        locationImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(15)
        }
        locationView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(locationImage.snp.right).offset(4)
            make.right.equalToSuperview().inset(8)
        }
    }
    
    func putUserAchievement() {
        let userAchieveItem1 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.backgroundColor = Gray.bright
            $0.text = "🇰🇷 Lv.1"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 1
            $0.layer.borderColor = Gray.semiLight.withAlphaComponent(0.6).cgColor
            $0.layer.cornerRadius = 4
            $0.layer.masksToBounds = true
        }
        
        let userAchieveItem2 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "📷 Lv.7"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        userAchievementStackView.addArrangedSubview(userAchieveItem1)
    }
    
    func makeInteractionCount(_ count: [Int]) {
        var index = 0
        interactionStackView.arrangedSubviews.forEach { view in
            guard let label = view.viewWithTag(1) as? UILabel else { return }
            label.text = String(count[index])
            index += 1
        }
    }
}
