//
//  MyScrapViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/30.
//

import UIKit
import RxSwift
import RxCocoa

class MyScrapViewController: UIViewController {
    
    weak var delegate: AddPlanDelegate?
    let animator = PopAnimator()
    
    var planID = ""
    var modifyMode = false
    var modifyStart = false
    
    lazy var viewModel = MyScrapViewModel(planID: planID)
    let disposeBag = DisposeBag()
    
    lazy var backgroundView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true)
    }
    
    var modalView = UIView().then {
        $0.backgroundColor = Gray.white
    }
    
    var modalIndicator = UIView().then {
        $0.backgroundColor = Gray.semiLight
    }
    
    var myScrapLabel = UILabel().then {
        $0.text = "내 스크랩"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var modifyButton = UIButton().then {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(Gray.medium, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(17)
    }
    
    lazy var myScrapFlowLayout = UICollectionViewFlowLayout().then {
        let width = (view.bounds.width - 50)/2
        let height = width * 4/3
        $0.itemSize = CGSize(width: width, height: height)
        $0.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
        $0.minimumLineSpacing = 10
        $0.minimumInteritemSpacing = 10
    }
    
    lazy var myScrapCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then {
        $0.collectionViewLayout = myScrapFlowLayout
    }
    
    var placeHolderLabel = UILabel().then {
        $0.text = "저장된 스크랩이 없어요.\n홈에서 스크랩을 추가해보세요."
        $0.font = Pretendard.semiBold(24)
        $0.textColor = Gray.semiLight
        let attrString = NSMutableAttributedString(string: $0.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 16
        attrString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attrString.length))
        $0.attributedText = attrString
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrapCollectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
            make.height.equalTo(700)
        }
        modalView.makeModalCircular()
        
        modalView.addSubview(modalIndicator)
        modalIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(36)
            make.height.equalTo(4)
        }
        modalIndicator.rounded(axis: .horizontal)
        
        modalView.addSubview(myScrapLabel)
        myScrapLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(modifyButton)
        modifyButton.snp.makeConstraints { make in
            make.centerY.equalTo(myScrapLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        modalView.addSubview(myScrapCollectionView)
        myScrapCollectionView.snp.makeConstraints { make in
            make.top.equalTo(myScrapLabel.snp.bottom).offset(10)
            make.left.centerX.bottom.equalToSuperview()
        }
        
        modalView.addSubview(placeHolderLabel)
        placeHolderLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
        }
    }
    
    func setRx() {
        modifyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.modifyStart = true
                self?.modifyMode.toggle()
                self?.myScrapCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: myScrapCollectionView.rx.items(cellIdentifier: "NFTCollectionViewCell", cellType: NFTCollectionViewCell.self)) { (row, element, cell) in
                if element.NFTID != "" {
                    cell.isUserInteractionEnabled = true
                    cell.addButton.isHidden = false
                    cell.NFTImageView.sd_setImage(with: URL(string: element.url), placeholderImage: nil, options: .scaleDownLargeImages)
                    if self.modifyStart {
                        let buttonImage = self.modifyMode ? "SmallMinus" : "SmallPlus"
                        UIView.transition(with: cell.addButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                            cell.addButton.setImage(UIImage(named: buttonImage), for: .normal)
                        }, completion: nil)
                    }
                    cell.addTapped = {
                        if self.modifyMode {
                            self.scrapDeleteAlert() {
                                self.viewModel.deleteScrap(planID: self.planID, NFTID: element.NFTID)
                            }
                        } else {
                            self.dismiss(animated: true)
                            self.delegate?.presentAddPlanModal(planID: self.planID, NFTID: element.NFTID)
                        }
                    }
                } else {
                    cell.isUserInteractionEnabled = false
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.itemCount
            .subscribe(onNext: { [weak self] count in
                if count == 0 {
                    self?.placeHolderLabel.isHidden = false
                } else {
                    self?.placeHolderLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        myScrapCollectionView.rx.modelSelected(NFT.self)
            .subscribe(onNext:{ [weak self] NFT in
                let virtualVC = ChangableNavigationController(rootViewController: VirtualViewController())
                let vc = RecordFullScreenViewController()
                vc.byScrapVC = true
                vc.url = URL(string: NFT.url)
                vc.NFTResult = NFT
                virtualVC.pushViewController(vc, animated: true)
                virtualVC.transitioningDelegate = self
                virtualVC.modalPresentationStyle = .overFullScreen
                self?.present(virtualVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func scrapDeleteAlert(_ alertHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "스크랩을 삭제하시겠어요?", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: "삭제", style: .default) { action in
            alertHandler()
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(UIColor.red, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension MyScrapViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPath = myScrapCollectionView.indexPathsForSelectedItems,
              let selectedCell = myScrapCollectionView.cellForItem(at: selectedIndexPath.first!) as? NFTCollectionViewCell,
              let selectedCellSuperView = selectedCell.superview else { return nil }
        
        animator.originFrame = selectedCellSuperView.convert(selectedCell.frame, to: nil)
        animator.image = selectedCell.NFTImageView.image
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let selectedIndexPath = myScrapCollectionView.indexPathsForSelectedItems,
              let selectedCell = myScrapCollectionView.cellForItem(at: selectedIndexPath.first!) as? NFTCollectionViewCell,
              let selectedCellSuperView = selectedCell.superview else { return nil }
        
        animator.originFrame = selectedCellSuperView.convert(selectedCell.frame, to: nil)
        animator.image = selectedCell.NFTImageView.image
        return animator
    }
}

//MARK: - UIViewControllerAnimatedTransitioning
class PopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.25
    var image: UIImage? = UIImage()
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        //presented Animation
        if let toView = transitionContext.view(forKey: .to) {
            toView.clipsToBounds = true
            toView.layer.cornerRadius = 8
            containerView.addSubview(toView)
            toView.frame = originFrame
            
            let snapShotView = UIImageView().then {
                $0.image = image
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
            containerView.addSubview(snapShotView)
            snapShotView.frame = originFrame
            
            UIView.animate(withDuration: duration, animations: {
                snapShotView.frame = containerView.frame
                toView.frame.origin = containerView.frame.origin
                toView.frame.size = containerView.frame.size
            }, completion: { _ in
                snapShotView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
        
        //dismissed Animation
        if let fromView = transitionContext.view(forKey: .from) {
            fromView.clipsToBounds = true
            fromView.layer.cornerRadius = 8
            containerView.addSubview(fromView)
            
            let snapShotView = UIImageView().then {
                $0.image = image
                $0.contentMode = .scaleAspectFill
                $0.clipsToBounds = true
                $0.layer.cornerRadius = 8
            }
            containerView.addSubview(snapShotView)
            snapShotView.frame = fromView.frame
            
            UIView.animate(withDuration: duration, animations: {
                snapShotView.frame = self.originFrame
                fromView.frame.origin = self.originFrame.origin
                fromView.frame.size = self.originFrame.size
            }, completion: { _ in
                snapShotView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}
