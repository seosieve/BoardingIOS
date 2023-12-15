//
//  NFTViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/06.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseStorage

class NFTViewController: UIViewController {

    let modalClosed = BehaviorRelay<Bool>(value: true)
    
    let viewModel = NFTViewModel()
    let disposeBag = DisposeBag()
    
    var NFTScrollView = UIScrollView()
    
    var NFTContentView = UIView()
    
    lazy var NFTnumberLabel = UILabel().then {
        $0.textColor = Gray.medium
        $0.font = Pretendard.regular(17)
    }
    
    var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "Triangle"), for: .normal)
        $0.setTitle("등록순", for: .normal)
        $0.setTitleColor(Gray.medium, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(16)
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    lazy var NFTFlowLayout = UICollectionViewFlowLayout().then {
        let width = (view.bounds.width - 50)/2
        let height = width * 4/3
        $0.itemSize = CGSize(width: width, height: height)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
    }
    
    lazy var NFTCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = NFTFlowLayout
    }
    
    var placeHolderLabel = UILabel().then {
        $0.text = "등록된 NFT가 없습니다.\n아래 버튼을 눌러 여행을 기록해보세요."
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
        self.view.backgroundColor = Gray.white
        NFTScrollView.delegate = self
        NFTCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
        setRx()
        updateViewHeight(count: 10)
    }
    
    func setViews() {
        view.addSubview(NFTScrollView)
        NFTScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NFTScrollView.addSubview(NFTContentView)
        NFTContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
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
            make.bottom.equalToSuperview().offset(-200)
        }
                
        NFTContentView.addSubview(placeHolderImage)
        placeHolderImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(100)
        }
        
        NFTContentView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(placeHolderImage.snp.top).offset(-16)
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
        
        sortButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showMenu()
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: NFTCollectionView.rx.items(cellIdentifier: "NFTCollectionViewCell", cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                if element.NFTID != "" {
                    cell.NFTImageView.sd_setImage(with: URL(string: element.url), placeholderImage: nil, options: .scaleDownLargeImages)
                    cell.isUserInteractionEnabled = true
                } else {
                    cell.isUserInteractionEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { [weak self] count in
                if count == 0 {
                    self?.NFTnumberLabel.isHidden = true
                    self?.sortButton.isHidden = true
                    self?.placeHolderLabel.isHidden = false
                    self?.placeHolderImage.isHidden = false
                } else {
                    self?.NFTnumberLabel.isHidden = false
                    self?.sortButton.isHidden = false
                    self?.placeHolderLabel.isHidden = true
                    self?.placeHolderImage.isHidden = true
                    self?.NFTnumberLabel.text = "총 \(count)개"
                }
                self?.updateViewHeight(count: count)
            })
            .disposed(by: disposeBag)
        
        NFTCollectionView.rx.modelSelected(NFT.self)
            .subscribe(onNext:{ [weak self] NFT in
                let presentingVC = self?.parent?.parent as? MyPageViewController
                let vc = NFTDetailViewController()
                vc.url = URL(string: NFT.url)
                vc.NFTResult = NFT
                vc.hidesBottomBarWhenPushed = true
                presentingVC?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewHeight(count: Int) {
        // UICollectionView의 높이를 업데이트
        let width = (view.bounds.width - 50)/2
        let height = width * 4/3 + 10
        let numberOfCells = ceil(Double(count)/Double(2))
        let totalHeight = height * numberOfCells
        NFTCollectionView.snp.updateConstraints { make in
            make.height.equalTo(totalHeight)
        }
    }
    
    func showMenu() {
        let registrationOrder = UIAction(title: "등록순", state: .on, handler: { _ in
            self.viewModel.stopListening()
            self.viewModel.getMyNFTByDate()
        })
        let popularityOrder = UIAction(title: "인기순", handler: { _ in
            self.viewModel.stopListening()
            self.viewModel.getMyNFTByLikes()
        })
        sortButton.menu = UIMenu(options: .displayInline, children: [registrationOrder, popularityOrder])
        sortButton.showsMenuAsPrimaryAction = true
        sortButton.changesSelectionAsPrimaryAction = true
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
