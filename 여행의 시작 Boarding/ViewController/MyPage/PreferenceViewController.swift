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
        preferenceTableView.delegate = self
        preferenceTableView.dataSource = self
        preferenceTableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "menuTableViewCell")
        setViews()
        test()
    }
    
    func test() {
        viewModel.token
            .bind(to: testLabel1.rx.text)
            .disposed(by: disposeBag)
        
//        viewModel.user
//            .compactMap{$0}
//            .bind
//            .subscribe(onNext: { user in
//                self.testLabel1.text = String(user.id!)
//                self.testLabel2.text = user.kakaoAccount?.email
//                self.testLabel3.text = user.kakaoAccount?.profile?.nickname
//            })
//            .disposed(by: disposeBag)
//        UserApi.shared.rx.me { (user, error) in
//            if let error = error {
//                print(error)
//            } else {
//                guard let id = user?.id ,let email = user?.kakaoAccount?.email, let name = user?.kakaoAccount?.profile?.nickname else {
//                    print("Error: email/name is empty")
//                    return
//                }
//
//                print(id)
//                print(email)
//                print(name)
//            }
//        }
        
        
        
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
            make.left.equalToSuperview().offset(100)
        }
        
        view.addSubview(testLabel3)
        testLabel3.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(280)
            make.left.equalToSuperview().offset(200)
        }
    }
    
    func logoutAlert() {
        let alert = UIAlertController(title: "정말 로그아웃 하시겠어요?", message: "로그아웃 후 Boarding를 이용하시려면 다시 로그인을 해 주세요!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .default) { action in
            self.viewModel.kakaoLogout()
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        logout.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITableView
extension PreferenceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.menuLabel.text = menuArr[indexPath.row]
        cell.detailButton.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print(indexPath.row)
        case 1:
            print(indexPath.row)
        case 2:
            print(indexPath.row)
        case 3:
            logoutAlert()
        default:
            print(indexPath.row)
        }
    }
}

