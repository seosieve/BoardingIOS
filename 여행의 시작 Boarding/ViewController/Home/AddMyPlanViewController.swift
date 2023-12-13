//
//  AddMyPlanViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/13.
//

import UIKit
import RxSwift
import RxCocoa

class VirtualViewController: UIViewController {}

class AddMyPlanViewController: UIViewController {
    
    var NFTID = ""

    let viewModel = AddMyPlanViewModel()
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
    
    var addMyPlanLabel = UILabel().then {
        $0.text = "내 플랜에 추가"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    lazy var addPlanButton = UIButton().then {
        $0.setImage(UIImage(named: "BluePlus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(addPlanButtonPressed), for: .touchUpInside)
    }
    
    @objc func addPlanButtonPressed() {
        let virtualVC = UINavigationController(rootViewController: VirtualViewController())
        let vc = NewPlanViewController()
        vc.byHomeVC = true
        virtualVC.pushViewController(vc, animated: true)
        presentVC(virtualVC, transition: .coverVertical)
    }
    
    var planScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.contentOffset = CGPoint(x: -20, y: 0)
    }
    
    var planStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    @objc func planStackViewSelected(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? StringStoredView else { return }
        view.isUserInteractionEnabled = false
        viewModel.findScrap(planID: view.storedString, NFTID: NFTID) { alreadyExist in
            if alreadyExist {
                self.toastAlert()
                view.isUserInteractionEnabled = true
            } else {
                self.indicator.startAnimating()
                self.viewModel.addScrap(planID: view.storedString, NFTID: self.NFTID)
                self.viewModel.addSaveCount(NFTID: self.NFTID)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dismissKeyboardWhenTapped()
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
            make.height.equalTo(380)
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
        
        modalView.addSubview(addMyPlanLabel)
        addMyPlanLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(addPlanButton)
        addPlanButton.snp.makeConstraints { make in
            make.centerY.equalTo(addMyPlanLabel)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(24)
        }
        
        modalView.addSubview(planScrollView)
        planScrollView.snp.makeConstraints { make in
            make.top.equalTo(addMyPlanLabel.snp.bottom).offset(20)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(266)
        }
        
        planScrollView.addSubview(planStackView)
        planStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    func makeEmptyStackView() {
        planStackView.removeAllArrangedSubviews()
        let subview = UIView()
        
        let borderView = UIView().then {
            $0.backgroundColor = Gray.white
            $0.layer.borderWidth = 1
            $0.layer.borderColor = Gray.semiLight.cgColor
        }
        
        let backgroundView = UIImageView().then {
            $0.backgroundColor = Gray.semiLight
        }
        
        let addImageView = UIImageView().then {
            $0.image = UIImage(named: "LargePlus")
        }
        
        lazy var addButton = UIButton().then {
            $0.backgroundColor = .clear
            $0.addTarget(self, action: #selector(addPlanButtonPressed), for: .touchUpInside)
        }
        
        let makeNewLabel = UILabel().then {
            $0.text = "새로 만들기"
            $0.font = Pretendard.semiBold(17)
            $0.textColor = Gray.black
        }
        
        subview.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        subview.addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.centerX.equalToSuperview()
            make.height.equalTo(210)
        }
        borderView.rounded(axis: .vertical)
        
        borderView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        backgroundView.rounded(axis: .vertical)
        
        borderView.addSubview(addImageView)
        addImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        borderView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addButton.rounded(axis: .vertical)
        
        subview.addSubview(makeNewLabel)
        makeNewLabel.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        
        planStackView.addArrangedSubview(subview)
    }
    
    func makeStackView(_ planArr: [Plan]) {
        planStackView.removeAllArrangedSubviews()
        for index in 0..<planArr.count {
            let subview = StringStoredView().then {
                $0.storedString = planArr[index].planID
                let tap = UITapGestureRecognizer(target: self, action: #selector(planStackViewSelected(_:)))
                tap.cancelsTouchesInView = false
                $0.addGestureRecognizer(tap)
            }
            
            let borderView = UIView().then {
                $0.backgroundColor = Gray.white
                $0.layer.borderWidth = 1
                $0.layer.borderColor = Gray.semiLight.cgColor
            }
            
            let placeHolderView = UIView().then {
                $0.backgroundColor = Gray.bright
            }
            
            let placeHolderImage = UIImageView().then {
                $0.image = UIImage(named: "TitleWhite")
            }
            
            let travelImageView = UIImageView().then {
                $0.backgroundColor = .clear
                let url = planArr[index].thumbnail == "" ? URL(string: "") : URL(string: planArr[index].thumbnail)
                $0.sd_setImage(with: url, placeholderImage: nil, options: .scaleDownLargeImages)
                $0.contentMode = .scaleAspectFill
            }
            
            let mainLabel = UILabel().then {
                $0.text = planArr[index].title
                $0.font = Pretendard.semiBold(17)
                $0.textColor = Gray.dark
            }
            
            let subLabel = UILabel().then {
                $0.text = planArr[index].location
                $0.font = Pretendard.regular(13)
                $0.textColor = Gray.light
            }
            
            subview.snp.makeConstraints { make in
                make.width.equalTo(160)
            }
            
            subview.addSubview(borderView)
            borderView.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.left.centerX.equalToSuperview()
                make.height.equalTo(210)
            }
            borderView.rounded(axis: .vertical)
            
            borderView.addSubview(placeHolderView)
            placeHolderView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(5)
            }
            placeHolderView.rounded(axis: .vertical)
            
            placeHolderView.addSubview(placeHolderImage)
            placeHolderImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(20)
                make.width.equalTo(120)
                make.height.equalTo(30)
            }
            
            borderView.addSubview(travelImageView)
            travelImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(5)
            }
            travelImageView.rounded(axis: .vertical)
            
            subview.addSubview(mainLabel)
            mainLabel.snp.makeConstraints { make in
                make.top.equalTo(borderView.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
            }
            
            subview.addSubview(subLabel)
            subLabel.snp.makeConstraints { make in
                make.top.equalTo(mainLabel.snp.bottom).offset(4)
                make.centerX.equalToSuperview()
            }
            planStackView.addArrangedSubview(subview)
        }
        
        modalView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.items
            .subscribe(onNext: { [weak self] planArr in
                if planArr.count == 0 {
                    self?.makeEmptyStackView()
                } else {
                    self?.makeStackView(planArr)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext: {
                self.indicator.stopAnimating()
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
