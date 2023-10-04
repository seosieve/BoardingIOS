//
//  NFTViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class NFTViewController: UIViewController {

    let tag = 0
    let cellCount = 15
    let modalClosed = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var NFTScrollView = UIScrollView()
    
    var NFTContentView = UIView()
    
    var NFTnumberLabel = UILabel().then {
        $0.text = "총 36개"
        $0.textColor = Gray.dark
        $0.font = Pretendard.regular(17)
    }
    
    var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "Triangle"), for: .normal)
        $0.setTitle("등록순", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(16)
    }
    
    var NFTCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .red
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.bright
        NFTScrollView.delegate = self
        NFTCollectionView.delegate = self
        NFTCollectionView.dataSource = self
        NFTCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
        setRx()
        updateCollectionViewHeight()
        updateScrollViewHeight()
    }
    
    func setViews() {
        view.addSubview(NFTScrollView)
        NFTScrollView.addSubview(NFTContentView)
        NFTScrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        NFTContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(3000)
        }
        
        NFTContentView.addSubview(NFTnumberLabel)
        NFTnumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(20)
        }
        
        NFTContentView.addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.right.equalToSuperview().offset(-20)
        }
        
        NFTContentView.addSubview(NFTCollectionView)
        NFTCollectionView.snp.makeConstraints { make in
            make.top.equalTo(NFTnumberLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(1)
        }
    }
    
    func setRx() {
        modalClosed.subscribe(onNext: { isClosed in
            if isClosed {
                self.NFTScrollView.isScrollEnabled = false
            } else {
                self.NFTScrollView.isScrollEnabled = true
            }
        })
        .disposed(by: disposeBag)
    }
    
    func updateCollectionViewHeight() {
        let width = (view.bounds.width - 50)/2
        let height = width*4/3 + 10
        let numberOfCells = ceil(Double(cellCount)/Double(2))
        print(numberOfCells)
        NFTCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height*numberOfCells)
        }
    }
    
    func updateScrollViewHeight() {
        // UIScrollView의 높이를 업데이트
        
    }
}

//MARK: - UIScrollView
extension NFTViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            scrollView.isScrollEnabled = false
        }
    }
}

//MARK: - UICollectionView
extension NFTViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as! NFTCollectionViewCell
        cell.NFTImageView.image = UIImage(named: "France1")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.bounds.width - 50)/2
        let height = width*4/3
        return CGSize(width: width, height: height)
    }
}
