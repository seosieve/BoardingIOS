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

    var cellCount = 10
    let modalClosed = BehaviorRelay<Bool>(value: true)
    
    let viewModel = NFTViewModel()
    let disposeBag = DisposeBag()
    
    var NFTScrollView = UIScrollView()
    
    var NFTContentView = UIView()
    
    lazy var NFTnumberLabel = UILabel().then {
        $0.textColor = Gray.dark
        $0.font = Pretendard.regular(17)
    }
    
    var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "Triangle"), for: .normal)
        $0.setTitle("등록순", for: .normal)
        $0.setTitleColor(Gray.dark, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(16)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        $0.semanticContentAttribute = .forceRightToLeft
        let registrationOrder = UIAction(title: "등록순", state: .on, handler: { _ in
            print("등록순")
        })
        let popularityOrder = UIAction(title: "인기순", handler: { _ in
            print("인기순")
        })
        $0.menu = UIMenu(options: .displayInline, children: [registrationOrder, popularityOrder])
        $0.showsMenuAsPrimaryAction = true
        $0.changesSelectionAsPrimaryAction = true
    }
    
    lazy var NFTCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.backgroundColor = .clear
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.itemSize = {
            let width = (self.view.bounds.width - 54)/2
            let height = width*4/3
            return CGSize(width: width, height: height)
        }()
        $0.collectionViewLayout = layout
        $0.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.bright
        NFTScrollView.delegate = self
//        NFTCollectionView.delegate = self
//        NFTCollectionView.dataSource = self
        NFTCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
        setRx()
        updateViewHeight()
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
            make.height.equalTo(1)
        }
        
        NFTContentView.addSubview(NFTnumberLabel)
        NFTnumberLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.left.equalToSuperview().offset(20)
        }
        
        NFTContentView.addSubview(sortButton)
        sortButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        NFTContentView.addSubview(NFTCollectionView)
        NFTCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
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
        
//        viewModel.images
//            .subscribe(onNext: { image in
//                print(image.count)
//            })
//            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: NFTCollectionView.rx.items(cellIdentifier: "NFTCollectionViewCell", cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                if element.NFTID != "" {
                    self.viewModel.downloadImage(urlString: element.url) { image in
                        cell.NFTImageView.image = image
                    }
                }
            }
            .disposed(by: disposeBag)
        
        NFTCollectionView.rx.modelSelected(NFT.self)
            .subscribe(onNext:{ [weak self] NFT in
                print(NFT)
            })
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { [weak self] count in
                self?.cellCount = count
                self?.NFTnumberLabel.text = "총 \(count)개"
                self?.updateViewHeight()
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewHeight() {
        // UICollectionView, ScrollContentView의 높이를 업데이트
        let width = (view.bounds.width - 54)/2
        let height = width*4/3 + 10
        let numberOfCells = ceil(Double(cellCount)/Double(2))
        let totalHeight = height * numberOfCells
        NFTCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
        NFTContentView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight + 250)
        }
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
//extension NFTViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return cellCount
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionViewCell", for: indexPath) as! NFTCollectionViewCell
//        cell.NFTImageView.image = UIImage(named: "France1")
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (view.bounds.width - 54)/2
//        let height = width*4/3
//        return CGSize(width: width, height: height)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let presentingVC = self.parent?.parent as? MyPageViewController
//        let vc = NFTDetailViewController()
//        vc.hidesBottomBarWhenPushed = true
//        presentingVC?.navigationController?.pushViewController(vc, animated: true)
//    }
//}
