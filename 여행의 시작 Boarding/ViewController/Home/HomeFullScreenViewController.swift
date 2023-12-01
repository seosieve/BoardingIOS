//
//  HomeFullScreenViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/05.
//

import UIKit
import AVKit

class HomeFullScreenViewController: UIViewController {
    
    var url: URL?
    var NFT: NFT?
    var user: User?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    var fullScreenImageView = UIImageView().then {
        $0.image = UIImage()
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var fullScreenDimView = UIView().then {
        $0.backgroundColor = Gray.black.withAlphaComponent(0.5)
        $0.alpha = 0
    }
    
    lazy var fullScreenGradientView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 198)
        $0.gradient([Gray.black.withAlphaComponent(0), .black], axis: .vertical)
    }
    
    lazy var fullScreenTextView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized() {
        if contentLabel.numberOfLines == 2 {
            UIView.animate(withDuration: 0.5) {
                self.contentLabel.numberOfLines = 0
                self.fullScreenDimView.alpha = 1
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.contentLabel.numberOfLines = 2
                self.fullScreenDimView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
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
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
    }
    
    lazy var locationButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.5), for: .normal)
        $0.setImage(UIImage(named: "Place")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setTitle(NFT?.location, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(13)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 9)
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(moveToInfo), for: .touchUpInside)
    }
    
    lazy var categoryButton = UIButton().then {
        $0.adjustsImageWhenHighlighted = false
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.5), for: .normal)
        $0.setImage(UIImage(named: "Plane")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.setTitle(NFT?.category, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(13)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 9)
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: -5, bottom: 5, right: 0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(moveToInfo), for: .touchUpInside)
    }
    
    @objc func moveToInfo() {
        let vc = HomeInfoViewController()
        vc.image = fullScreenImageView.image
        vc.NFTResult = NFT!
        vc.user = user!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    @objc func iconButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            break
        default:
            sender.isSelected.toggle()
            sender.touchAnimation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadVideoView()
        loadImageView()
        setViews()
    }
    
    func setViews() {
        view.addSubview(fullScreenImageView)
        fullScreenImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(fullScreenDimView)
        fullScreenDimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(fullScreenGradientView)
        fullScreenGradientView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(198)
        }
        
        view.addSubview(fullScreenTextView)
        fullScreenTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-82)
            make.bottom.equalToSuperview().inset(90)
        }
        
        fullScreenTextView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        fullScreenTextView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(contentLabel.snp.top).offset(-10)
        }
        
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(54)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        locationButton.rounded(axis: .horizontal)
        
        view.addSubview(categoryButton)
        categoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(locationButton)
            make.left.equalTo(locationButton.snp.right).offset(8)
            make.height.equalTo(24)
        }
        categoryButton.rounded(axis: .horizontal)
        
        view.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().inset(84)
            make.width.equalTo(32)
        }
        let icon = [InteractionInfo.comment, InteractionInfo.like, InteractionInfo.save]
        for index in 0..<icon.count {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            
            lazy var iconButton = UIButton().then {
                $0.tag = index
                $0.setImage(icon[index].0.withRenderingMode(.alwaysTemplate), for: .normal)
                $0.setImage(icon[index].1.withRenderingMode(.alwaysTemplate), for: .selected)
                $0.tintColor = Gray.white
                $0.addTarget(self, action: #selector(iconButtonPressed(_:)), for: .touchUpInside)
            }
            
            let numberLabel = UILabel().then {
                $0.text = "0"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.white
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
    }
    
    func loadVideoView() {
        guard let path = Bundle.main.path(forResource: "Eiffel", ofType: "mp4") else { return }
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
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
