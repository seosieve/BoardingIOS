//
//  HomeInfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/30.
//

import UIKit
import MapKit

class HomeInfoViewController: UIViewController {

    var image: UIImage?
    
    var infoTitle = ["위치", "시간", "날씨"]
    var infoDetail = ["", "", "맑음, 25°C"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var photoView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 1
        $0.backgroundColor = Gray.light.withAlphaComponent(0.4)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    var contentLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
        $0.numberOfLines = 0
    }
    
    var aa = RoundedMapView().then {
        $0.backgroundColor = .red
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
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
        
        let navigationDivider = divider()
        view.addSubview(navigationDivider)
        navigationDivider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(navigationDivider).offset(16)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(200)
            make.width.equalTo(150)
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(photoView)
            make.left.equalTo(photoView.snp.right).offset(9)
            make.height.equalTo(photoView)
            make.right.equalToSuperview().inset(24)
        }
        for index in 0...2 {
            let subview = UIView().then {
                $0.backgroundColor = Gray.white
            }
            let mainLabel = UILabel().then {
                $0.text = infoTitle[index]
                $0.textColor = Gray.black
                $0.font = Pretendard.semiBold(16)
            }
            let subLabel = UILabel().then {
                $0.text = infoDetail[index]
                $0.textColor = Gray.dark
                $0.font = Pretendard.regular(14)
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            mainLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.top.equalToSuperview().offset(10)
            }
            subLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().inset(10)
            }
            infoStackView.addArrangedSubview(subview)
        }
        
        let photoDivider = divider()
        view.addSubview(photoDivider)
        photoDivider.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(18)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(4)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoDivider).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(aa)
        aa.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(200)
        }
    }

}

class RoundedMapView: UIView {

    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMapView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMapView()
    }

    private func setupMapView() {
        addSubview(mapView)

        // MapView을 UIView와 같은 크기로 설정
        mapView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        // UIView에 라운드 처리
        layer.cornerRadius = 10
        layer.masksToBounds = true
    }
}
