//
//  FullScreenViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/05.
//

import UIKit
import AVKit
import Then
import SnapKit

class FullScreenViewController: UIViewController {
    
    var url: URL?
    var NFT: NFT?
    var User: User?
    
    let iconArr = [UIImage(named: "Comment"), UIImage(named: "Like"), UIImage(named: "Save")]
    
    var fullScreenImageView = UIImageView().then {
        $0.image = UIImage(named: "France1")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var fullScreenTextView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 198)
        $0.gradient([Gray.black.withAlphaComponent(0), .black], axis: .vertical)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized() {
        let vc = HomeInfoViewController()
        vc.image = fullScreenImageView.image
        vc.infoDetail[0] = NFT!.location
        vc.infoDetail[1] = NFT!.time
        vc.titleLabel.text = NFT!.title
        vc.contentLabel.text = NFT!.content
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = NFT?.title
        $0.font = Pretendard.medium(19)
        $0.textColor = Gray.white
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = NFT?.content
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byClipping
    }
    
    var locationView = UIView().then {
        $0.backgroundColor = Gray.light.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 12
    }
    
    var locationImage = UIImageView().then {
        $0.image = UIImage(named: "Location")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.white
    }
    
    lazy var locationLabel = UILabel().then {
        $0.text = NFT?.location
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.white
    }
    
    var categoryView = UIView().then {
        $0.backgroundColor = Gray.light.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 12
    }
    
    var categoryImage = UIImageView().then {
        $0.image = UIImage(named: "Location")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.white
    }
    
    var categoryLabel = UILabel().then {
        $0.text = "액티비티"
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.white
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 15
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGreen
//        loadVideoView()
        loadImageView()
        setViews()
    }
    
    func setViews() {
        view.addSubview(fullScreenImageView)
        fullScreenImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(fullScreenTextView)
        fullScreenTextView.snp.makeConstraints { make in
            make.left.centerX.bottom.equalToSuperview()
            make.height.equalTo(195)
        }
        
        fullScreenTextView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.left.equalToSuperview().offset(17)
        }
        
        fullScreenTextView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(17)
            make.right.equalToSuperview().offset(-82)
        }
        
        fullScreenTextView.addSubview(locationView)
        locationView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
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
        
        fullScreenTextView.addSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.centerY.equalTo(locationView)
            make.left.equalTo(locationView.snp.right).offset(8)
            make.height.equalTo(24)
        }
        categoryView.addSubview(categoryImage)
        categoryImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(11)
            make.height.equalTo(15)
        }
        categoryView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(categoryImage.snp.right).offset(4)
            make.right.equalToSuperview().inset(8)
        }
        
        view.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().inset(83)
            make.width.equalTo(33)
            make.height.equalTo(198)
        }
        for index in 0..<iconArr.count {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            
            let iconImageView = UIImageView().then {
                $0.image = iconArr[index]?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = Gray.white
            }
            
            let numberLabel = UILabel().then {
                $0.text = "0"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.white
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
    }
    
    func loadVideoView() {
        guard let path = Bundle.main.path(forResource: "Eiffel", ofType: "mp4") else { return }
        let player = AVPlayer.init(url: URL(filePath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player.play()
    }
    
    func loadImageView() {
        fullScreenImageView.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages)
    }
}
