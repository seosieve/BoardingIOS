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

class PreferenceViewController: UIViewController {
    
    let viewModel = PreferenceViewModel()
    let disposeBag = DisposeBag()
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var preferenceTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.rowHeight = 60
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        preferenceTableView.register(PreferenceTableViewCell.self, forCellReuseIdentifier: "preferenceTableViewCell")
        setViews()
        setRx()
    }
    
    func setViews() {
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
    
    func setRx() {
        viewModel.items
            .bind(to: preferenceTableView.rx.items(cellIdentifier: "preferenceTableViewCell", cellType: PreferenceTableViewCell.self)) { (row, element, cell) in
                cell.mainLabel.text = element
                switch row {
                case 0, 1, 2, 3:
                    cell.detailButton.isHidden = false
                case 4:
                    cell.versionLabel.isHidden = false
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        let message = viewModel.messageArr.value
        
        preferenceTableView.rx.itemSelected
            .map{$0.row}
            .subscribe(onNext:{ [weak self] index in
                switch index {
                case 0:
                    let vc = EditProfileViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                case 1:
                    let vc = BlockedUserViewController()
                    self?.navigationController?.pushViewController(vc, animated: true)
                case 2:
                    let vc = TermsViewController()
                    vc.terms = "이용약관"
                    self?.navigationController?.pushViewController(vc, animated: true)
                case 3:
                    let vc = TermsViewController()
                    vc.terms = "개인정보 보호 정책"
                    self?.navigationController?.pushViewController(vc, animated: true)
                case 5:
                    self?.preferenceAlert(message[0], index)
                case 6:
                    self?.preferenceAlert(message[1], index)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.errorCatch
            .subscribe(onNext:{ [weak self] error in
                if error {
                    self?.indicator.stopAnimating()
                    self?.errorAlert()
                    self?.view.isUserInteractionEnabled = true
                } else {
                    self?.indicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext:{ [weak self] in
                self?.indicator.stopAnimating()
                self?.presentVC(UINavigationController(rootViewController: StartViewController()), transition: .crossDissolve)
            })
            .disposed(by: disposeBag)
    }
    
    func preferenceAlert(_ message: (String, String, String), _ index: Int) {
        let alert = UIAlertController(title: message.0, message: message.1, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: message.2, style: .default) { action in
            self.indicator.startAnimating()
            self.view.isUserInteractionEnabled = false
            if index == 4 {
                self.viewModel.logOut()
            } else {
                self.viewModel.unLink()
            }
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}

