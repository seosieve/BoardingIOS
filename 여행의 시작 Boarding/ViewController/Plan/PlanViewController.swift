//
//  PlanViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import RxSwift
import RxCocoa

class PlanViewController: UIViewController {

    var previousIndex = 0
    
    let viewModel = PlanViewModel()
    let disposeBag = DisposeBag()
    
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
    
    var addPlanButton = UIButton().then {
        $0.setImage(UIImage(named: "BluePlus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.medium
    }
    
    lazy var planFlowLayout = UICollectionViewFlowLayout().then {
        $0.itemSize = CGSize(width: view.bounds.width - 60, height: 550)
        $0.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
    }
    
    lazy var planCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = planFlowLayout
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = false
        $0.decelerationRate = .fast
    }
    
    var addPlanView = UIView()
    
    var addButton = UIButton().then {
        $0.setImage(UIImage(named: "LargePlus"), for: .normal)
        $0.backgroundColor = Gray.semiLight
        $0.adjustsImageWhenHighlighted = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = Gray.white
        planCollectionView.register(PlanCollectionViewCell.self, forCellWithReuseIdentifier: "planCollectionViewCell")
        setViews()
        setRx()
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
            make.height.equalTo(60)
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
            make.centerX.left.equalToSuperview()
            make.height.equalTo(550)
        }
        
        makeAddPlanView()
    }
    
    func makeAddPlanView() {
        view.addSubview(addPlanView)
        addPlanView.snp.makeConstraints { make in
            make.top.equalTo(planView.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(550)
        }
        
        let borderView = UIView().then {
            $0.backgroundColor = Gray.white
        }
        addPlanView.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(400)
        }
        borderView.rounded(axis: .vertical)
        borderView.layer.masksToBounds = false
        borderView.makeShadow(opacity: 0.3, shadowRadius: 10)
        
        borderView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        addButton.rounded(axis: .vertical)
        
        let addLabel = UILabel().then {
            $0.text = "새로 만들기"
            $0.font = Pretendard.semiBold(25)
            $0.textColor = Gray.semiDark
        }
        addPlanView.addSubview(addLabel)
        addLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    func setRx() {
        addPlanButton.rx.tap
            .subscribe(onNext: {
                let vc = NewPlanViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        planCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: planCollectionView.rx.items(cellIdentifier: "planCollectionViewCell", cellType: PlanCollectionViewCell.self)) { (row, element, cell) in
                if element.planID != "" {
                    cell.photoTapped = {
                        let vc = PlanDetailViewController()
                        vc.plan = element
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.mainLabel.text = element.title
                    cell.durationLabel.text = "\(element.boarding) ~ \(element.landing)"
                    cell.locationLabel.text = element.location
                    cell.DdayLabel.text = makeDday(boardingDate: element.boarding)
                    
                    if cell.DdayLabel.text!.count > 3 {
                        cell.DdayLabel.backgroundColor = Gray.medium
                    } else {
                        cell.DdayLabel.backgroundColor = Boarding.red
                    }
                } else {
                    
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { [weak self] count in
                if count == 0 {
                    self?.addPlanView.isHidden = false
                } else {
                    self?.addPlanView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(onNext: {
                let vc = NewPlanViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension UIImage {
    func convertToGrayScale() -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectMono") {
            filter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
            if let output = filter.outputImage,
               let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}

//MARK: - UICollectionView
extension PlanViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
//        let cellWidth = self.view.bounds.width - 60
//        let index = round(scrolledOffsetX / cellWidth)
//        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
//        
//        let previous = previousIndex
//        previousIndex = Int(index)
//        
//        if let previousCell = planCollectionView.cellForItem(at: IndexPath(item: Int(previous), section: 0)) as? PlanCollectionViewCell {
//            UIView.transition(with: previousCell.travelImageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
//                previousCell.travelImageView.image = self.planArr[Int(previous)].0?.convertToGrayScale()
//            }, completion: nil)
//        }
//        
//        if let cell = planCollectionView.cellForItem(at: IndexPath(item: Int(index), section: 0)) as? PlanCollectionViewCell {
//            UIView.transition(with: cell.travelImageView, duration: 1.0, options: .transitionCrossDissolve, animations: {
//                cell.travelImageView.image = self.planArr[Int(index)].0
//            }, completion: nil)
//        }
//    }
}
