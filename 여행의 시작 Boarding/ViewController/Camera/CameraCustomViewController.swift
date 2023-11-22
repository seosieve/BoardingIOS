//
//  CameraCustomViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/10.
//

import UIKit

class CameraCustomViewController: UIViewController {

    var image: UIImage?
    var location: (String, String, String, Double, Double)?
    var time: String?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
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
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(16)
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        let vc = WrittingViewController()
        vc.infoArr = [location!.0, time!, "맑음, 25°C"]
        vc.country = location!.1
        vc.city = location!.2
        vc.latitude = location!.3
        vc.longitude = location!.4
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Gray.black
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
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.right.equalToSuperview().offset(-19)
        }
    }
}
