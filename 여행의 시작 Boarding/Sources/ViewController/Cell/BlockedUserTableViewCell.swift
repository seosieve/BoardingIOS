//
//  BlockedUserTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/12/05.
//

import UIKit
import RxSwift
import RxCocoa

class BlockedUserTableViewCell: UITableViewCell {

    var unblockTapped: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    var userImage = UIImageView().then {
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
    }
    
    var userNameLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.medium(17)
        $0.textColor = Gray.semiDark
    }
    
    var unblockButton = UIButton().then {
        $0.backgroundColor = Gray.white
        $0.setTitle("차단 해제", for: .normal)
        $0.setTitleColor(Gray.light, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.titleLabel?.font = Pretendard.medium(13)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setRx()
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
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(48)
        }
        userImage.loadingAnimation()
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.left.equalTo(userImage.snp.right).offset(20)
        }
        
        contentView.addSubview(unblockButton)
        unblockButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(70)
            make.height.equalTo(28)
        }
        unblockButton.rounded(axis: .horizontal)
    }
    
    func setRx() {
        unblockButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.unblockTapped?()
            })
            .disposed(by: disposeBag)
    }
}
