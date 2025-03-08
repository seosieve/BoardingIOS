//
//  NFTCollectionViewCell.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/04.
//

import UIKit
import RxSwift
import RxCocoa

class NFTCollectionViewCell: UICollectionViewCell {
    
    var addTapped: (() -> Void)?
    
    let disposeBag = DisposeBag()
    
    var NFTImageView = UIImageView().then {
        $0.image = UIImage()
        $0.backgroundColor = Gray.bright
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    var addButton = UIButton().then {
        $0.setImage(UIImage(named: "SmallPlus"), for: .normal)
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setRx()
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
            make.edges.equalToSuperview()
        }
        NFTImageView.loadingAnimation()
        
        contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().inset(8)
            make.width.height.equalTo(32)
        }
        addButton.makeShadow()
    }
    
    func setRx() {
        addButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.addTapped?()
            })
            .disposed(by: disposeBag)
    }
}
