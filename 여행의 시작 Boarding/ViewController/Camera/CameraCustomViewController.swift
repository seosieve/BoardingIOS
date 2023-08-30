//
//  CameraCustomViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/10.
//

import UIKit

class CameraCustomViewController: UIViewController {

    var image: UIImage?
    
    var customImageView = UIImageView().then {
        $0.image = UIImage(named: "France8")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.white
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setViews()
    }
    
    func setViews() {
        view.addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        customImageView.image = image
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
    }
}
