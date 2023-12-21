//
//  RecordViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import RxSwift
import RxCocoa

class RecordViewController: UIViewController {
    
    let viewModel = RecordViewModel()
    let disposeBag = DisposeBag()
    
    var statusBarView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var recordScrollView = UIScrollView()
    
    var recordContentView = UIView()
    
    var pastTravelLabel = UILabel().then {
        $0.text = "지난 여행"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var addPastTravelButton = UIButton().then {
        $0.setImage(UIImage(named: "BluePlus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.medium
    }
    
    lazy var pastTravelFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: 176, height: 280)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
    }
    
    lazy var pastTravelCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = pastTravelFlowLayout
        $0.showsHorizontalScrollIndicator = false
    }
    
    var recordLabel = UILabel().then {
        $0.text = "내 기록"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var recordFlowLayout = UICollectionViewFlowLayout().then {
        let width = (view.bounds.width - 48)/3
        let height = width * 4/3
        $0.itemSize = CGSize(width: width, height: height)
        $0.minimumInteritemSpacing = 4
        $0.minimumLineSpacing = 4
    }
    
    lazy var recordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = recordFlowLayout
    }
    
    var placeHolderLabel = UILabel().then {
        $0.text = "등록된 CARD가 없습니다.\n아래 버튼을 눌러 여행을 기록해보세요."
        $0.font = Pretendard.regular(20)
        $0.textColor = Gray.medium
        $0.withLineSpacing(12)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    var placeHolderImage = UIImageView().then {
        $0.image = UIImage(named: "Arrow")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        pastTravelCollectionView.register(TravelCollectionViewCell.self, forCellWithReuseIdentifier: "travelCollectionViewCell")
        recordCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(statusBarView)
        statusBarView.snp.makeConstraints { make in
            make.top.centerX.width.equalToSuperview()
            make.height.equalTo(window.safeAreaInsets.top)
        }
        
        view.insertSubview(recordScrollView, belowSubview: statusBarView)
        recordScrollView.addSubview(recordContentView)
        recordScrollView.snp.makeConstraints { make in
            make.top.equalTo(statusBarView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        recordContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
//        
//        recordContentView.addSubview(pastTravelLabel)
//        pastTravelLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(15)
//            make.left.equalToSuperview().inset(20)
//        }
//        
//        recordContentView.addSubview(addPastTravelButton)
//        addPastTravelButton.snp.makeConstraints { make in
//            make.top.equalToSuperview().inset(15)
//            make.right.equalToSuperview().inset(20)
//            make.width.height.equalTo(20)
//        }
//        
//        recordContentView.addSubview(pastTravelCollectionView)
//        pastTravelCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(pastTravelLabel.snp.bottom).offset(20)
//            make.centerX.left.equalToSuperview()
//            make.height.equalTo(280)
//        }
//        
//        let recordDivider = divider()
//        recordContentView.addSubview(recordDivider)
//        recordDivider.snp.makeConstraints { make in
//            make.top.equalTo(pastTravelCollectionView.snp.bottom).offset(16)
//            make.centerX.left.equalToSuperview()
//            make.height.equalTo(1)
//        }
//
        recordContentView.addSubview(recordLabel)
        recordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().inset(20)
        }
        
        recordContentView.addSubview(recordCollectionView)
        recordCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recordLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-56)
        }
        
        recordContentView.addSubview(placeHolderImage)
        placeHolderImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(170)
            make.height.equalTo(90)
            make.width.equalTo(26)
        }
        
        recordContentView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(placeHolderImage.snp.top).offset(-16)
        }
    }
    
    func setRx() {
        addPastTravelButton.rx.tap
            .subscribe(onNext: {
                let vc = PastTravelViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.pastTravelItems
            .bind(to: pastTravelCollectionView.rx.items(cellIdentifier: "travelCollectionViewCell", cellType: TravelCollectionViewCell.self)) { (row, element, cell) in
                cell.travelImageView.image = element.0
                cell.mainLabel.text = element.1
                cell.subLabel.text = element.2
            }
            .disposed(by: disposeBag)
        
        viewModel.recordItems
            .bind(to: recordCollectionView.rx.items(cellIdentifier: "NFTCollectionViewCell", cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                if element.NFTID != "" {
                    cell.NFTImageView.sd_setImage(with: URL(string: element.url), placeholderImage: nil, options: .scaleDownLargeImages)
                    cell.isUserInteractionEnabled = true
                } else {
                    cell.isUserInteractionEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.recordItemCount
            .subscribe(onNext: { [weak self] count in
                if count == 0 {
                    self?.placeHolderLabel.isHidden = false
                    self?.placeHolderImage.isHidden = false
                } else {
                    self?.placeHolderLabel.isHidden = true
                    self?.placeHolderImage.isHidden = true
                }
                self?.updateViewHeight(count: count)
            })
            .disposed(by: disposeBag)
        
        recordCollectionView.rx.modelSelected(NFT.self)
            .subscribe(onNext:{ [weak self] NFT in
                let vc = RecordFullScreenViewController()
                vc.url = URL(string: NFT.url)
                vc.NFTResult = NFT
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewHeight(count: Int) {
        // UICollectionView의 높이를 업데이트
        let width = (view.bounds.width - 48)/3
        let height = width * 4/3 + 4
        let numberOfCells = ceil(Double(count)/Double(3))
        let totalHeight = height * numberOfCells
        recordCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
    }
}
