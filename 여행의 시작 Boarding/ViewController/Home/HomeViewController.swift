//
//  HomeViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    
    private var lastContentOffset: CGFloat = 0

    let popularScheduleArr = [(UIImage(named: "France8"), "파리 4박 여행", "파리, 프랑스"), (UIImage(named: "France9"), "유럽 축구 여행", "런던, 바르셀로나"), (UIImage(named: "France10"), "2023 세느강 야경", "파리, 프랑스")]
    
    let recommendPlaceArr = [(UIImage(named: "France1"), 5.0, "에펠탑"), (UIImage(named: "France2"), 2.9, "바토무슈 크루즈"), (UIImage(named: "France3"), 3.8, "루브르 박물관")]
    
    let popularPlaceArr = [(UIImage(named: "France4"), 3.9, "개선문"), (UIImage(named: "France5"), 3.7, "몽마르트 언덕"), (UIImage(named: "France6"), 5.0, "퐁피두 센터"), (UIImage(named: "France7"), 4.2, "노트르담 대성당")]
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var iconView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(named: "Search"), for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action:#selector(searchButtonPressed), for: .touchUpInside)
    }
    
    @objc func searchButtonPressed() {
        print("searchButton Pressed")
    }
    
    lazy var alarmButton = UIButton().then {
        $0.setImage(UIImage(named: "Alarm"), for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(alarmButtonPressed), for: .touchUpInside)
    }
    
    @objc func alarmButtonPressed() {
        print("alarmButton Pressed")
    }
    
    var homeScrollView = UIScrollView()
    
    var homeContentView = UIView()
    
    var popularScheduleLabel = UILabel().then {
        $0.text = "인기 여행 일정"
        $0.font = Pretendard.bold(20)
        $0.textColor = Gray.black
    }
    
    var popularScheduleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    var recommendPlaceLabel = UILabel().then {
        $0.text = "정현님을 위한 추천 여행지"
        $0.font = Pretendard.bold(20)
        $0.textColor = Gray.black
    }
    
    var recommendPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    var popularPlaceLabel = UILabel().then {
        $0.text = "인기 여행지"
        $0.font = Pretendard.bold(20)
        $0.textColor = Gray.black
    }
    
    var popularPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        popularScheduleCollectionView.delegate = self
        popularScheduleCollectionView.dataSource = self
        popularScheduleCollectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: "scheduleCollectionViewCell")
        recommendPlaceCollectionView.delegate = self
        recommendPlaceCollectionView.dataSource = self
        recommendPlaceCollectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: "placeCollectionViewCell")
        popularPlaceCollectionView.delegate = self
        popularPlaceCollectionView.dataSource = self
        popularPlaceCollectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: "placeCollectionViewCell")
        homeScrollView.delegate = self
        setViews()
    }

    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        iconView.addSubview(searchButton)
        iconView.addSubview(alarmButton)
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalTo(alarmButton.snp.left).offset(-12)
            make.top.equalToSuperview().offset(14)
        }
        alarmButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(14)
        }
        
        view.insertSubview(homeScrollView, belowSubview: iconView)
        homeScrollView.addSubview(homeContentView)
        homeScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(statusBarView.snp.bottom)
        }
        homeContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(950)
        }
        
        homeContentView.addSubview(popularScheduleLabel)
        homeContentView.addSubview(popularScheduleCollectionView)
        popularScheduleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(65)
            make.left.equalToSuperview().inset(16)
        }
        popularScheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularScheduleLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        homeContentView.addSubview(recommendPlaceLabel)
        homeContentView.addSubview(recommendPlaceCollectionView)
        recommendPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(popularScheduleCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        recommendPlaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendPlaceLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        homeContentView.addSubview(popularPlaceLabel)
        homeContentView.addSubview(popularPlaceCollectionView)
        popularPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendPlaceCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        popularPlaceCollectionView.snp.makeConstraints { make in
            make.top.equalTo(popularPlaceLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func drawStar(_ score: Double) -> [UIImage] {
        var starArr: [UIImage] = []
        for i in 1...5 {
            let star = i <= Int(score) ? "Star" : "EmptyStar"
            starArr.append(UIImage(named: star)!)
        }
        return starArr
    }
}

//MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case popularScheduleCollectionView:
            return 3
        case recommendPlaceCollectionView:
            return 3
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
    UICollectionViewCell {
        if collectionView == popularScheduleCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCollectionViewCell", for: indexPath) as! ScheduleCollectionViewCell
            cell.scheduleImageView.image = popularScheduleArr[indexPath.row].0
            cell.scheduleTitleLabel.text = popularScheduleArr[indexPath.row].1
            cell.scheduleSubLabel.text = popularScheduleArr[indexPath.row].2
            return cell
        } else if collectionView == recommendPlaceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCollectionViewCell", for: indexPath) as! PlaceCollectionViewCell
            cell.placeImageView.image = recommendPlaceArr[indexPath.row].0
            var star = drawStar(recommendPlaceArr[indexPath.row].1)
            for view in cell.placeStarStackView.arrangedSubviews {
                if let imgView = view as? UIImageView {
                    imgView.image = star.removeFirst()
                }
            }
            cell.placeScore.text = String(recommendPlaceArr[indexPath.row].1)
            cell.placeLabel.text = recommendPlaceArr[indexPath.row].2
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCollectionViewCell", for: indexPath) as! PlaceCollectionViewCell
            cell.placeImageView.image = popularPlaceArr[indexPath.row].0
            var star = drawStar(popularPlaceArr[indexPath.row].1)
            for view in cell.placeStarStackView.arrangedSubviews {
                if let imgView = view as? UIImageView {
                    imgView.image = star.removeFirst()
                }
            }
            cell.placeScore.text = String(popularPlaceArr[indexPath.row].1)
            cell.placeLabel.text = popularPlaceArr[indexPath.row].2
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case popularScheduleCollectionView:
            return CGSize(width: 165, height: 260)
        case recommendPlaceCollectionView:
            return CGSize(width: 150, height: 200)
        default:
            return CGSize(width: 150, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case popularScheduleCollectionView:
            print(indexPath.row)
            let vc = FullScreenViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        case recommendPlaceCollectionView:
            break
        default:
            break
        }
    }
}

//MARK: - UIScrollView
extension HomeViewController: UIScrollViewDelegate {
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
//        let level = translation.y
//        print(level)
//        iconView.snp.updateConstraints { make in
//            var value: CGFloat = 0
//            switch level {
//            case ..<0:
//                value = window.safeAreaInsets.top
//            case 0...45:
//                value = window.safeAreaInsets.top - level
//            default:
//                value = 0
//            }
    //            make.top.equalTo(value)
    //        }
    //        searchButton.alpha = 1 - level*0.03
    //        alarmButton.alpha = 1 - level*0.03
    //    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let level = scrollView.contentOffset.y
        print(level)
        if (self.lastContentOffset == scrollView.contentOffset.y) {
            print("aa")
            iconView.snp.updateConstraints {make in
                make.top.equalTo(0)
            }
            return
        }
        
        iconView.snp.updateConstraints { make in
            var value: CGFloat = 0
            switch level {
            case ..<0:
                value = window.safeAreaInsets.top
            case 0...45:
                value = window.safeAreaInsets.top - level
            default:
                value = 0
            }
            make.top.equalTo(value)
        }
        searchButton.alpha = 1 - level*0.03
        alarmButton.alpha = 1 - level*0.03
        
        
        
        self.lastContentOffset = scrollView.contentOffset.y
        print(lastContentOffset)
    }
}

