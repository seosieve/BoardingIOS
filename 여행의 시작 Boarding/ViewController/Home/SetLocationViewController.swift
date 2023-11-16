//
//  SetLocationViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/23.
//

import UIKit

class SetLocationViewController: UIViewController {

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
    
    var setLocationLabel = UILabel().then {
        $0.text = "지역설정"
        $0.font = Pretendard.semiBold(25)
        $0.textColor = Gray.black
    }
    
    var searchView = UIView().then {
        $0.backgroundColor = Gray.bright
        $0.layer.cornerRadius = 12
    }
    
    var searchImageView = UIImageView().then {
        $0.image = UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Gray.light
    }
    
    var searchTextField = UITextField().then {
        $0.placeholder = "국가, 도시 검색"
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dismissKeyboardWhenTapped()
        setViews()
    }

    func setViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.centerX.left.bottom.equalToSuperview().inset(0)
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
        
        modalView.addSubview(setLocationLabel)
        setLocationLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(setLocationLabel.snp.bottom).offset(14)
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchView.addSubview(searchImageView)
        searchImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        searchView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(searchImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
