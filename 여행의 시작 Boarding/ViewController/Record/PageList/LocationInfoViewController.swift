//
//  LocationInfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMaps

class LocationInfoViewController: UIViewController {
    
    var NFTResult = NFT.dummyType
    
    lazy var viewModel = LocationInfoViewModel(latitude: NFTResult.latitude, longitude: NFTResult.longitude)
    let disposeBag = DisposeBag()
    
    var mapView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 24
    }
    
    lazy var locationLabel = UILabel().then {
        $0.text = NFTResult.location
        $0.font = Pretendard.semiBold(21)
        $0.textColor = Gray.black
    }
    
    var locationSubLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(13)
        $0.textColor = Gray.medium
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    
    lazy var camera = GMSCameraPosition.camera(withLatitude: NFTResult.latitude, longitude: NFTResult.longitude, zoom: 14.0)
    
    lazy var map = GMSMapView(frame: CGRect.zero, camera: camera).then {
        $0.settings.scrollGestures = false
        $0.settings.zoomGestures = false
        $0.settings.tiltGestures = false
        $0.settings.rotateGestures = false
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    lazy var marker = GMSMarker().then {
        $0.position = CLLocationCoordinate2D(latitude: NFTResult.latitude, longitude: NFTResult.longitude)
        $0.icon = GMSMarker.markerImage(with: Boarding.blue)
        $0.map = map
    }
    
    var locationDetailButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        var title = AttributedString.init("장소 상세정보")
        title.font = Pretendard.medium(19)
        config.baseBackgroundColor = Gray.white
        config.baseForegroundColor = Boarding.blue
        config.attributedTitle = title
        config.background.cornerRadius = 20
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    
    var locationDetailImage = UIImageView().then {
        $0.image = UIImage(named: "Detail")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Boarding.blue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.bright
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        mapView.addSubview(locationLabel)
        locationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(20)
        }
        
        mapView.addSubview(locationSubLabel)
        locationSubLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.left.equalTo(locationLabel)
            make.centerX.equalToSuperview()
        }
        
        mapView.addSubview(map)
        map.snp.makeConstraints { make in
            make.top.equalTo(locationSubLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalTo(locationSubLabel)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        view.addSubview(locationDetailButton)
        locationDetailButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.equalTo(mapView)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }
        
        locationDetailButton.addSubview(locationDetailImage)
        locationDetailImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
    }
    
    func setRx() {
        viewModel.locationAddress
            .bind(to: locationSubLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.marker
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.marker.title = $0.0
                self?.marker.snippet = $0.1
            })
            .disposed(by: disposeBag)
        
        locationDetailButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.showGoogleMap(location: self?.NFTResult.location)
            })
            .disposed(by: disposeBag)
    }
}
