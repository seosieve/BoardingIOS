//
//  SearchViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var delegate: SearchDelegate?
    
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
    
    var searchLabel = UILabel().then {
        $0.text = "검색"
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
    
    lazy var searchTextField = UITextField().then {
        $0.placeholder = "검색어 입력"
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ sender: UITextField) {
        if sender.text == "" {
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
        }
    }
    
    lazy var searchButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        $0.isEnabled = false
    }
    
    @objc func searchButtonPressed() {
        searchTextField.resignFirstResponder()
        delegate?.searchNFT(word: searchTextField.text!)
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        searchTextField.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setViews()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboard = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let keyboardHeight = keyboard.height
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.searchButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(keyboardHeight+10)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.searchButton.snp.updateConstraints { make in
                make.bottom.equalToSuperview().inset(30)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func setViews() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(modalView)
        modalView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200) // was 100
            make.centerX.left.bottom.equalToSuperview()
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
        
        modalView.addSubview(searchLabel)
        searchLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.left.equalToSuperview().offset(20)
        }
        
        modalView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(searchLabel.snp.bottom).offset(14)
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
        
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        searchButton.rounded(axis: .horizontal)
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
