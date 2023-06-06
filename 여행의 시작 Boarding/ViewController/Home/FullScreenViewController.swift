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
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true)
    }
    
    lazy var fullScreenTextView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 195)
        $0.gradient([Gray.black.withAlphaComponent(0), .black], axis: .vertical)
    }
    
    var userImageView = UIImageView().then {
        $0.image = UIImage(named: "DefaultUser")
    }
    
    var userIdLabel = UILabel().then {
        $0.text = "junhokim"
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.white
    }
    
    var contentsLabel = UILabel().then {
        $0.text = "프랑스 혁명 기념일에 매년 전통 불꽃 놀이가 프랑스 수도에서 가장 상징적인 건축물, 에펠탑을 중심으로 독특한 볼거리를 연출한다."
        $0.font = Pretendard.regular(14)
        $0.textColor = Gray.white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byClipping
    }
    
    var reportButton = UIButton().then {
        $0.setImage(UIImage(named: "Report"), for: .normal)
        $0.setTitle("12", for: .normal)
    }
    
    var saveButton = UIButton().then {
        $0.setImage(UIImage(named: "Save"), for: .normal)
    }
    
    var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "Like"), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGreen
        loadVideoView()
        setViews()
    }
    
    func setViews() {
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
        
        fullScreenTextView.addSubview(userImageView)
        fullScreenTextView.addSubview(userIdLabel)
        fullScreenTextView.addSubview(contentsLabel)
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.left.equalToSuperview().offset(24)
            make.width.height.equalTo(28)
        }
        userIdLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView)
            make.left.equalTo(userImageView.snp.right).offset(4)
        }
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(userIdLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
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
}
