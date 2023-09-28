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

    let menuArr = ["이용약관", "개인정보 보호 정책", "버전정보", "로그아웃", "회원탈퇴"]
    
    let viewModel = PreferenceViewModel()
    let disposeBag = DisposeBag()
    
    var divider = UIView().then {
        $0.backgroundColor = UITableView().separatorColor
    }
    
    var preferenceTableView = UITableView().then {
        $0.isScrollEnabled = false
        $0.rowHeight = 60
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var testLabel1 = UILabel().then {
        $0.text = "토큰"
        $0.textColor = .white
        $0.backgroundColor = .blue
    }
    
    var testLabel2 = UILabel().then {
        $0.text = "이메일"
        $0.textColor = .white
        $0.backgroundColor = .blue
    }
    
    var testLabel3 = UILabel().then {
        $0.text = "닉네임"
        $0.textColor = .white
        $0.backgroundColor = .blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setNavigationBar()
        self.view.backgroundColor = Gray.white
        preferenceTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuTableViewCell")
        setViews()
        test()
        setRx()
    }
    
    func test() {
        viewModel.token
            .bind(to: testLabel1.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.email
            .bind(to: testLabel2.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.nickname
            .bind(to: testLabel3.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setViews() {
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(self.navigationController!.navigationBar.bottom())
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.3)
        }
        
        view.addSubview(preferenceTableView)
        preferenceTableView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(300)
        }
        
        view.addSubview(testLabel1)
        testLabel1.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(280)
            make.left.equalToSuperview()
        }
        
        view.addSubview(testLabel2)
        testLabel2.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(280)
            make.left.equalTo(testLabel1.snp.right).offset(10)
        }
        
        view.addSubview(testLabel3)
        testLabel3.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(280)
            make.left.equalTo(testLabel2.snp.right).offset(10)
        }
    }
    
    func setRx() {
        viewModel.items
            .bind(to: preferenceTableView.rx.items) { (tableView, row, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: IndexPath(row: row, section: 0)) as! MenuTableViewCell
                cell.menuLabel.text = element
                cell.detailButton.isHidden = true
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
                    self?.errorAlert()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext:{ [weak self] completed in
                if completed {
                    self?.presentVC(UINavigationController(rootViewController: StartViewController()))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func popUpAlert(_ message: (String, String, String), _ index: Int) {
        let alert = UIAlertController(title: message.0, message: message.1, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: message.2, style: .default) { action in
            if index == 3 {
                self.viewModel.kakaoLogOut()
            } else {
                self.viewModel.kakaoUnLink()
            }
        }
        alert.addAction(cancel)
        alert.addAction(action)
        action.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}

