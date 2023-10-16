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

    let planArr = [(UIImage(named: "France11"), "2024 뉴욕 여행", "23.07.10 ~ 23.07.25"), (UIImage(named: "France10"), "여름방학 프랑스 여행", "23.07.10 ~ 23.07.25"), (UIImage(named: "France9"), "유럽 축구 여행", "파리, 프랑스")]
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var planView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var planLabel = UILabel().then {
        $0.text = "여행 플랜"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var addPlanButton = UIButton().then {
        $0.setImage(UIImage(named: "BluePlus"), for: .normal)
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(addPlanButtonPressed), for: .touchUpInside)
    }
    
    @objc func addPlanButtonPressed() {
        let vc = NewPlanViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    var planCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .clear
        var layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .horizontal
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.bright
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
        planCollectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "planCollectionViewCell")
        setViews()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.centerX.top.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.addSubview(planView)
        planView.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(65)
        }
        
        planView.addSubview(planLabel)
        planLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
        }
        
        planView.addSubview(addPlanButton)
        addPlanButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(20)
        }
        
        view.addSubview(planCollectionView)
        planCollectionView.snp.makeConstraints { make in
            make.top.equalTo(planView.snp.bottom).offset(50)
            make.centerX.right.equalToSuperview()
            make.height.equalTo(550)
        }
    }
}

//MARK: - UICollectionView
extension PlanViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "planCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        cell.travelImageView.image = planArr[indexPath.row].0
        cell.mainLabel.text = planArr[indexPath.row].1
        cell.travelSubLabel.text = planArr[indexPath.row].2
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 550)
    }
}
