//
//  RecordViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import Then
import SnapKit

class RecordViewController: UIViewController {

    let planArr = [(UIImage(named: "France11"), "2024 뉴욕 여행", "미정"), (UIImage(named: "France10"), "여름방학 프랑스 여행", "23.07.10 ~ 23.07.25"), (UIImage(named: "France9"), "유럽 축구 여행", "파리, 프랑스")]
    
    let recordArr = [UIImage(named: "France10"), UIImage(named: "France9"), UIImage(named: "France8"), UIImage(named: "France7"), UIImage(named: "France6"), UIImage(named: "France5"), UIImage(named: "France4"), UIImage(named: "France3"), UIImage(named: "France2")]
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var recordScrollView = UIScrollView()
    
    var recordContentView = UIView()
    
    lazy var addPastTravelButton = UIButton().then {
        $0.setImage(UIImage(named: "BluePlus"), for: .normal)
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(addPastTravelButtonPressed), for: .touchUpInside)
    }
    
    @objc func addPastTravelButtonPressed() {
        let vc = MakePastTravelViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var pastTravelLabel = UILabel().then {
        $0.text = "지난 여행"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var pastTravelCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    var recordLabel = UILabel().then {
        $0.text = "내 기록"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var recordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        $0.collectionViewLayout = layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        pastTravelCollectionView.delegate = self
        pastTravelCollectionView.dataSource = self
        pastTravelCollectionView.register(TravelCollectionViewCell.self, forCellWithReuseIdentifier: "travelCollectionViewCell")
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self
        recordCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.insertSubview(recordScrollView, belowSubview: statusBarView)
        recordScrollView.addSubview(recordContentView)
        recordScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(statusBarView.snp.bottom)
        }
        recordContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1000)
        }
        
        recordContentView.addSubview(addPastTravelButton)
        addPastTravelButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
        
        recordContentView.addSubview(pastTravelLabel)
        recordContentView.addSubview(pastTravelCollectionView)
        pastTravelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
        }
        pastTravelCollectionView.snp.makeConstraints { make in
            make.top.equalTo(pastTravelLabel.snp.bottom).offset(20)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(270)
        }
        
        recordContentView.addSubview(recordLabel)
        recordContentView.addSubview(recordCollectionView)
        recordLabel.snp.makeConstraints { make in
            make.top.equalTo(pastTravelCollectionView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(20)
        }
        recordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(10)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(2000)
        }
    }
}

//MARK: - UICollectionView
extension RecordViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case pastTravelCollectionView:
            return 3
        default:
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == pastTravelCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelCollectionViewCell", for: indexPath) as! TravelCollectionViewCell
            cell.travelImageView.image = planArr[indexPath.row].0
            cell.travelTitleLabel.text = planArr[indexPath.row].1
            cell.travelSubLabel.text = planArr[indexPath.row].2
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as! NFTCollectionViewCell
            cell.NFTImageView.image = recordArr[indexPath.row]
            return cell
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case pastTravelCollectionView:
            return CGSize(width: 160, height: 270)
        default:
            let width = (view.bounds.width - 48)/3
            let height = width*4/3
            return CGSize(width: width, height: height)
        }
    }
}
