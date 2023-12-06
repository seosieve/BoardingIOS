//
//  HomeInfoViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import MapKit
import GoogleMaps

class HomeInfoViewController: UIViewController {
    
    var image: UIImage?
    var NFTResult = NFT.dummyType
    var user = User.dummyType
    
    private var lastContentOffset: CGPoint = .zero
    private var isFirstScroll = false
    
    lazy var viewModel = HomeInfoViewModel(latitude: NFTResult.latitude, longitude: NFTResult.longitude)
    let modalClosed = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.white
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var headerImageView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 24
        $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        $0.layer.masksToBounds = true
    }
    
    var headerVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    lazy var titleLabel = UILabel().then {
        $0.text = NFTResult.title
        $0.textColor = Gray.white
        $0.font = Pretendard.semiBold(25)
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
        $0.spacing = 0
        $0.backgroundColor = .clear
    }
    
    var infoScrollView = UIScrollView().then {
        $0.isScrollEnabled = false
        $0.backgroundColor = Gray.bright
    }
    
    lazy var infoContentView = UIView().then {
        $0.backgroundColor = Gray.white
        let pan = UIPanGestureRecognizer(target: self, action: #selector(addModalMotion))
        $0.addGestureRecognizer(pan)
    }
    
    @objc func addModalMotion(_ recognizer: UIPanGestureRecognizer) {
        let minY:CGFloat = -280
        let maxY:CGFloat = 0
        
        switch recognizer.state {
        case .began, .changed:
            let translation = recognizer.translation(in: infoContentView)
            let y = max(minY, min(maxY, headerImageView.frame.minY + translation.y))
            
            headerImageView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(y)
            }
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
        case .ended:
            let velocity = recognizer.velocity(in: infoContentView).y
            let shouldClose = velocity > 0
            print(shouldClose)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.photoView.alpha = shouldClose ? 1 : 0
                self.infoStackView.alpha = shouldClose ? 1 : 0
                self.headerImageView.snp.updateConstraints { make in
                    make.top.equalToSuperview().offset(shouldClose ? maxY : minY)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
            modalClosed.accept(shouldClose)
        default:
            break
        }
    }
    
    var userImage = UIImageView().then {
        $0.image = UIImage()
        $0.tintColor = Boarding.blue
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    lazy var userNameLabel = UILabel().then {
        $0.backgroundColor = Gray.white
        $0.text = user.name
        $0.font = Pretendard.medium(19)
        $0.textColor = Gray.black
    }
    
    lazy var starValue = UILabel().then {
        $0.text = String(Double(NFTResult.starPoint))
        $0.font = Pretendard.regular(17)
        $0.textColor = Boarding.blue
    }
    
    let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 0
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = NFTResult.content
        $0.textColor = Gray.dark
        $0.font = Pretendard.regular(17)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    var interactionStackView = UIStackView().then {
        $0.backgroundColor = .clear
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 15
    }
    
    @objc func iconButtonPressed(_ sender: UIButton) {
        print("icon Pressed")
    }
    
    var mapBackgroundView = UIView().then {
        $0.backgroundColor = Gray.bright
    }
    
    var mapView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.cornerRadius = 20
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
    
    lazy var map = GMSMapView.map(withFrame: CGRect.zero, camera: camera).then {
        $0.layer.cornerRadius = 20
        $0.layer.masksToBounds = true
    }
    
    lazy var marker = GMSMarker().then {
        $0.position = CLLocationCoordinate2D(latitude: NFTResult.latitude, longitude: NFTResult.longitude)
        $0.title = ""
        $0.snippet = ""
        $0.map = map
    }
    
    var locationInfoLabel = UILabel().then {
        $0.text = ""
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.dark
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
    }
    
    var moreReviewButton = UIButton().then {
        $0.backgroundColor = Gray.white
        $0.setTitle("리뷰 더보기", for: .normal)
        $0.setTitleColor(Boarding.blue, for: .normal)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.layer.cornerRadius = 20
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isFirstScroll = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.white
        self.navigationController?.navigationBar.isHidden = true
        infoScrollView.delegate = self
        setViews()
        setRx()
    }
    
    func setViews() {
        userImage.sd_setImage(with: URL(string: user.url), placeholderImage: nil, options: .scaleDownLargeImages)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.insertSubview(headerImageView, belowSubview: backButton)
        headerImageView.snp.makeConstraints { make in
            make.top.left.centerX.equalToSuperview()
            make.height.equalTo(380)
        }
        
        headerImageView.addSubview(headerVisualEffectView)
        headerVisualEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(105)
            make.left.equalToSuperview().offset(20)
        }
        
        headerImageView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(200)
            make.width.equalTo(150)
        }
        
        headerImageView.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(photoView)
            make.left.equalTo(photoView.snp.right).offset(12)
            make.height.equalTo(photoView)
            make.right.equalToSuperview().inset(20)
        }
        let info = [NFTResult.location, NFTResult.time, NFTResult.weather]
        for index in 0...2 {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            let iconImageView = UIImageView().then {
                $0.image = PhotoInfo.icon[index]
            }
            let infoLabel = UILabel().then {
                $0.text = info[index]
                $0.textColor = Gray.white
                $0.font = Pretendard.regular(17)
            }
            let infoDivider = divider().then {
                $0.backgroundColor = Gray.white
                if index == 2 { $0.alpha = 0 }
            }
            
            subview.addSubview(iconImageView)
            subview.addSubview(infoLabel)
            subview.addSubview(infoDivider)
            iconImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(4)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
            infoLabel.snp.makeConstraints { make in
                make.left.equalTo(iconImageView.snp.right).offset(8)
                make.centerY.equalToSuperview()
                make.bottom.equalToSuperview().inset(10)
            }
            infoDivider.snp.makeConstraints { make in
                make.top.equalTo(subview.snp.bottom)
                make.centerX.left.equalToSuperview()
                make.height.equalTo(0.5)
            }
            infoStackView.addArrangedSubview(subview)
        }
        
        view.insertSubview(infoScrollView, belowSubview: headerImageView)
        infoScrollView.addSubview(infoContentView)
        infoScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(headerImageView.snp.bottom).offset(-20)
        }
        infoContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        infoContentView.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.left.equalToSuperview().offset(20)
            make.height.width.equalTo(32)
        }
        
        infoContentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImage)
            make.left.equalTo(userImage.snp.right).offset(4)
        }
        
        infoContentView.addSubview(starValue)
        starValue.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(32)
        }
        
        infoContentView.addSubview(starStackView)
        starStackView.snp.makeConstraints { make in
            make.centerY.equalTo(starValue)
            make.right.equalTo(starValue.snp.left).offset(-4)
        }
        for index in 0...4 {
            let star = UIImageView().then {
                $0.tintColor = Boarding.blue
            }
            if index < NFTResult.starPoint {
                star.image = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
            } else {
                star.image = UIImage(named: "EmptyStar")?.withRenderingMode(.alwaysTemplate)
            }
            star.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
            starStackView.addArrangedSubview(star)
        }
        
        infoContentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userImage.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        infoContentView.addSubview(interactionStackView)
        interactionStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        let icon = [InteractionInfo.like, InteractionInfo.comment, InteractionInfo.report]
        for index in 0..<icon.count {
            let subview = UIView().then {
                $0.backgroundColor = .clear
            }
            
            lazy var iconButton = UIButton().then {
                $0.tag = index
                $0.setImage(icon[index].0.withRenderingMode(.alwaysTemplate), for: .normal)
                $0.setImage(icon[index].1.withRenderingMode(.alwaysTemplate), for: .selected)
                $0.tintColor = Gray.dark
                $0.addTarget(self, action: #selector(iconButtonPressed(_:)), for: .touchUpInside)
            }
            
            let numberLabel = UILabel().then {
                $0.text = "0"
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.dark
                $0.textAlignment = .center
            }
            
            subview.addSubview(iconButton)
            iconButton.snp.makeConstraints { make in
                make.top.left.centerX.equalToSuperview()
                make.width.height.equalTo(30)
            }
            subview.addSubview(numberLabel)
            numberLabel.snp.makeConstraints { make in
                make.top.equalTo(iconButton.snp.bottom)
                make.left.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            interactionStackView.addArrangedSubview(subview)
        }
        
        infoContentView.addSubview(mapBackgroundView)
        mapBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(interactionStackView.snp.bottom).offset(24)
            make.centerX.left.bottom.equalToSuperview()
        }
        
        mapBackgroundView.addSubview(mapView)
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
            make.top.equalTo(locationLabel.snp.bottom).offset(2)
            make.left.equalTo(locationLabel)
            make.centerX.equalToSuperview()
        }
        
        mapView.addSubview(map)
        map.snp.makeConstraints { make in
            make.top.equalTo(locationSubLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.equalTo(locationSubLabel)
            make.height.equalTo(200)
        }
        
        mapView.addSubview(locationInfoLabel)
        locationInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(map.snp.bottom).offset(12)
            make.left.equalTo(map)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-16)
        }
        
        mapBackgroundView.addSubview(moreReviewButton)
        moreReviewButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.left.equalTo(mapView)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setRx() {
        modalClosed.subscribe(onNext: { [self] isClosed in
            if self.infoScrollView.bounds.height >= self.infoContentView.bounds.height { return }
            if isClosed {
                self.infoScrollView.isScrollEnabled = false
                if let panGestureRecognizer = self.findPan(for: self.infoContentView) {
                    panGestureRecognizer.isEnabled = true
                }
            } else {
                self.infoScrollView.isScrollEnabled = true
                if let panGestureRecognizer = self.findPan(for: self.infoContentView) {
                    panGestureRecognizer.isEnabled = false
                }
            }
        })
        .disposed(by: disposeBag)
        
        viewModel.locationAddress
            .bind(to: locationSubLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.locationInfo
            .bind(to: locationInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.marker
            .subscribe(onNext: { [weak self] in
                self?.marker.title = $0.0
                self?.marker.snippet = $0.1
            })
            .disposed(by: disposeBag)
    }
    
    func findPan(for view: UIView) -> UIPanGestureRecognizer? {
        for recognizer in view.gestureRecognizers ?? [] {
            if let pan = recognizer as? UIPanGestureRecognizer {
                return pan
            }
        }
        return nil
    }
}

//MARK: - UIScrollView
extension HomeInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isFirstScroll {
            scrollView.contentOffset.y = max(0, scrollView.contentOffset.y)
            let level = scrollView.contentOffset.y
            let currentContentOffset = scrollView.contentOffset
            if currentContentOffset.y < lastContentOffset.y && level == 0 {
                modalClosed.accept(true)
            }
            lastContentOffset = currentContentOffset
        }
    }
}
