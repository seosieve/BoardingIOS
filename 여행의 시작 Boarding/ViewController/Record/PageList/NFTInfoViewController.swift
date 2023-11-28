//
//  NFTInfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit

class NFTInfoViewController: UIViewController {

    var NFTResult = NFT.dummyType
    
    var NFTInfoView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
    }
    
    var titleLabel = UILabel().then {
        $0.text = "NFT 정보"
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var NFTInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 0
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.bright
        setViews()
    }
    
    func setViews() {
        view.addSubview(NFTInfoView)
        NFTInfoView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        
        NFTInfoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
        }
        
        NFTInfoView.addSubview(NFTInfoStackView)
        NFTInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(titleLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(220)
        }
        let info = [String(NFTResult.writtenDate), NFTResult.NFTID, "Standard", NFTResult.autherUid, "1", "5%"]
        for index in 0..<6 {
            let subview = UIView().then {
                $0.backgroundColor = UIColor.clear
            }
            let mainLabel = UILabel().then {
                $0.text = TicketInfo.QR[index]
                $0.font = Pretendard.regular(17)
                $0.textColor = Gray.medium
            }
            let subLabel = UILabel().then {
                $0.text = info[index]
                $0.font = Pretendard.regular(17)
                $0.textColor = Gray.dark
                $0.textAlignment = .right
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            mainLabel.snp.makeConstraints { make in
                make.centerY.left.equalToSuperview()
                make.width.equalTo(140)
            }
            subLabel.snp.makeConstraints { make in
                make.centerY.right.equalToSuperview()
                make.width.equalTo(110)
            }
            NFTInfoStackView.addArrangedSubview(subview)
        }
    }
}
