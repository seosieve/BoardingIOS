//
//  PreferenceViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/18.
//

import UIKit
import RxSwift
import RxCocoa
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

final class PreferenceViewController: UIViewController {
    
    private let viewModel = PreferenceViewModel()
    
    private let disposeBag = DisposeBag()
    
    private lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private let preferenceTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.rowHeight = 60
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.register(PreferenceTableViewCell.self, forCellReuseIdentifier: "preferenceTableViewCell")
    }
    
    private let indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        setViews()
        setRx()
    }
    
    private func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        let preferenceDivider = divider()
        view.addSubview(preferenceDivider)
        preferenceDivider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        view.addSubview(preferenceTableView)
        preferenceTableView.snp.makeConstraints { make in
            make.top.equalTo(preferenceDivider.snp.bottom)
            make.centerX.left.bottom.equalToSuperview()
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setRx() {
        Observable.just(Names.Preference.allCases)
            .bind(to: preferenceTableView.rx.items(cellIdentifier: "preferenceTableViewCell", cellType: PreferenceTableViewCell.self)) { row, element, cell in
                cell.mainLabel.text = element.title
                cell.configureCell(row)
            }
            .disposed(by: disposeBag)
        
        preferenceTableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                switch indexPath.row {
                case 0:
                    let vc = EditProfileViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vc = BlockedUserViewController()
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = TermsViewController()
                    vc.terms = Names.Preference.termsOfUse.title
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 3:
                    let vc = TermsViewController()
                    vc.terms = "개인정보 보호 정책"
                    owner.navigationController?.pushViewController(vc, animated: true)
                case 5:
                    owner.preferenceAlert(.logOut) {
                        ///User Interaction
                        self.indicator.startAnimating()
                        self.view.isUserInteractionEnabled = false
                        ///LogOut
                        self.viewModel.logOut()
                    }
                case 6:
                    owner.preferenceAlert(.withdraw) {
                        ///User Interaction
                        self.indicator.startAnimating()
                        self.view.isUserInteractionEnabled = false
                        ///UnLink
                        self.viewModel.unLink()
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.errorCatch
            .bind(with: self) { owner, error in
                if error {
                    owner.indicator.stopAnimating()
                    owner.errorAlert()
                    owner.view.isUserInteractionEnabled = true
                } else {
                    owner.indicator.stopAnimating()
                    owner.view.isUserInteractionEnabled = true
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .bind(with: self) { owner, _ in
                owner.indicator.stopAnimating()
                owner.presentVC(UINavigationController(rootViewController: StartViewController()), transition: .crossDissolve)
            }
            .disposed(by: disposeBag)
    }
    

}

