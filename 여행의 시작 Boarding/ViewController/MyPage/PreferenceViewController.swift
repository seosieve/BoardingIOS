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

    let menuArr = ["프로필 편집", "내정보", "이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"]
    
    let viewModel = PreferenceViewModel()
    let disposeBag = DisposeBag()
    
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
        self.navigationController?.navigationBar.setNavigationBar()
        self.view.backgroundColor = Gray.white
        preferenceTableView.register(PreferenceTableViewCell.self, forCellReuseIdentifier: "preferenceTableViewCell")
        setViews()
        setRx()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setViews() {
        view.addSubview(preferenceTableView)
        preferenceTableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom())
            make.centerX.left.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.items
            .bind(to: preferenceTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "preferenceTableViewCell", for: IndexPath(row: row, section: 0)) as! PreferenceTableViewCell
                cell.mainLabel.text = element
                if row == 3 || row == 4 {
                    cell.detailButton.isHidden = true
                }
                return cell
            }
            .disposed(by: disposeBag)
        
        let message = viewModel.messageArr.value
        
        preferenceTableView.rx.itemSelected
            .map{$0.row}
            .subscribe(onNext:{ [weak self] index in
                switch index {
                case 3:
                    self?.popUpAlert(message[0], index)
                case 4:
                    self?.popUpAlert(message[1], index)
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
    
    func popUpAlert(_ message: (String, String, String), _ index: Int) {
        let alert = UIAlertController(title: message.0, message: message.1, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: message.2, style: .default) { action in
            self.indicator.startAnimating()
            if index == 3 {
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

