//
//  HomeTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/05.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    var url: URL?
    var NFT: NFT?
    var User: User?
    
    let iconArr = [UIImage(named: "Report"), UIImage(named: "Comment"), UIImage(named: "Like"), UIImage(named: "Save")]
    
    var userImage = UIImageView().then {
        $0.image = UIImage(named: "DefaultUser")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Boarding.blue
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
    
    var photoView = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = Gray.white
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 15
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
        $0.text = "4.5"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
    }
    
    var locationView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 12
    }
    
    var locationImage = UIImageView().then {
        $0.image = UIImage(named: "Location")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.medium
    }
    
    var locationLabel = UILabel().then {
        $0.text = "루레알공원, 파리, 프랑스"
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
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.photoView.backgroundColor = Gray.white
        })
        
        contentView.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.left.equalTo(photoView.snp.right).offset(28)
            make.bottom.equalTo(photoView)
            make.width.equalTo(33)
            make.height.equalTo(262)
        }
        for index in 0...3 {
            let subview = UIView().then {
                $0.backgroundColor = Gray.white
            }
            
            let iconImageView = UIImageView().then {
                $0.image = iconArr[index]
            }
            
            let numberLabel = UILabel().then {
                $0.text = "0"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.dark
                $0.textAlignment = .center
            }
            
            subview.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { make in
                make.top.left.centerX.equalToSuperview()
                make.width.height.equalTo(32)
            }
            subview.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.top.equalTo(iconImageView.snp.bottom)
                make.left.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
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
            make.top.equalToSuperview().offset(5)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(15)
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
            make.width.equalTo(11)
            make.height.equalTo(15)
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
            $0.text = "🇰🇷 Lv.1"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
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
        
        let userAchieveItem3 = UILabel().then {
            $0.frame = CGRect(x: 0, y: 0, width: 54, height: 24)
            $0.text = "🏄‍♂️ Lv.5"
            $0.font = Pretendard.regular(12)
            $0.textAlignment = .center
            $0.textColor = Gray.dark
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = Gray.light.cgColor
            $0.layer.cornerRadius = 4
        }
        
        userAchievementStackView.addArrangedSubview(userAchieveItem1)
//        userAchievementStackView.addArrangedSubview(userAchieveItem2)
//        userAchievementStackView.addArrangedSubview(userAchieveItem3)
    }
}
