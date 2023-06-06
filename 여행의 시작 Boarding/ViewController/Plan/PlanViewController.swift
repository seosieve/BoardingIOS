//
//  PlanViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

class PlanViewController: UIViewController {

    let planArr = [(UIImage(named: "France11"), "2024 뉴욕 여행", "미정"), (UIImage(named: "France10"), "여름방학 프랑스 여행", "23.07.10 ~ 23.07.25"), (UIImage(named: "France9"), "유럽 축구 여행", "파리, 프랑스")]
    
    let scrapArr = [(UIImage(named: "France10"), "세느강"), (UIImage(named: "France9"), "FC 스타디움"), (UIImage(named: "France8"), "에펠탑"), (UIImage(named: "France7"), "노트르담 대성당"), (UIImage(named: "France6"), "퐁피두 센터"), (UIImage(named: "France5"), "몽마르트 언덕"), (UIImage(named: "France4"), "개선문"), (UIImage(named: "France3"), "루브르 박물관"), (UIImage(named: "France2"), "바토무슈 크루즈")]
    
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
    
    var planScrollView = UIScrollView()
    
    var planContentView = UIView()
    
    lazy var addPlanButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(Gray.black, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(18)
        $0.addTarget(self, action: #selector(addPlanButtonPressed), for: .touchUpInside)
    }
    
    @objc func addPlanButtonPressed() {
        print("aa")
    }
    
    var planLabel = UILabel().then {
        $0.text = "여행 계획"
        $0.font = Pretendard.bold(20)
        $0.textColor = Gray.black
    }
    
    var planCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    var scrapLabel = UILabel().then {
        $0.text = "스크랩"
        $0.font = Pretendard.bold(20)
        $0.textColor = Gray.black
    }
    
    var scrapCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 0
        layout.minimumInteritemSpacing = 0
        $0.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
        planCollectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: "scheduleCollectionViewCell")
        scrapCollectionView.delegate = self
        scrapCollectionView.dataSource = self
        scrapCollectionView.register(RecordCollectionViewCell.self, forCellWithReuseIdentifier: "recordCollectionViewCell")
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
        
        view.insertSubview(planScrollView, belowSubview: iconView)
        planScrollView.addSubview(planContentView)
        planScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(statusBarView.snp.bottom)
        }
        planContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1000)
        }
        
        planContentView.addSubview(addPlanButton)
        addPlanButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(65)
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(50)
        }
        
        planContentView.addSubview(planLabel)
        planContentView.addSubview(planCollectionView)
        planLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(65)
            make.left.equalToSuperview().inset(16)
        }
        planCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        planContentView.addSubview(scrapLabel)
        planContentView.addSubview(scrapCollectionView)
        scrapLabel.snp.makeConstraints { make in
            make.top.equalTo(planCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
        }
        scrapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scrapLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(2000)
        }
    }
}

//MARK: - UICollectionView
extension PlanViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case planCollectionView:
            return 3
        default:
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == planCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scheduleCollectionViewCell", for: indexPath) as! ScheduleCollectionViewCell
            cell.scheduleImageView.image = planArr[indexPath.row].0
            cell.scheduleTitleLabel.text = planArr[indexPath.row].1
            cell.scheduleSubLabel.text = planArr[indexPath.row].2
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recordCollectionViewCell", for: indexPath) as! RecordCollectionViewCell
            cell.recordImageView.image = scrapArr[indexPath.row].0
            cell.recordLabel.text = scrapArr[indexPath.row].1
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case planCollectionView:
            return CGSize(width: 165, height: 260)
        default:
            let width = (view.bounds.width - 32)/3
            let height = width*4/3
            return CGSize(width: width, height: height)
        }
    }
}
