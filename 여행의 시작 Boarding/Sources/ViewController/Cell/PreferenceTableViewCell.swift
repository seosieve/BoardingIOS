//
//  PreferenceTableViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit

final class PreferenceTableViewCell: UITableViewCell {

    var mainLabel = UILabel().then {
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.dark
    }
    
    private var detailButton = UIButton().then {
        $0.setImage(UIImage(named: "Detail")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.semiLight
        $0.isHidden = true
    }
    
    private var versionLabel = UILabel().then {
        $0.text = "1. 2. 6"
        $0.font = Pretendard.semiBold(16)
        $0.textColor = Gray.semiLight
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.isSelected = false
            }
        }
    }
    
    private func setViews() {
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        contentView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(28)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(25)
        }
    }
    
    func configureCell(_ index: Int) {
        switch index {
        case 0...3:
            detailButton.isHidden = false
        case 4:
            versionLabel.isHidden = false
        default:
            break
        }
    }
}
