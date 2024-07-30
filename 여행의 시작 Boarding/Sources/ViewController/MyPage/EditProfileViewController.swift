//
//  EditProfileViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 12/12/23.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseStorageUI

class EditProfileViewController: UIViewController {
    
    var thumbnailChanged = false
    
    let viewModel = EditProfileViewModel()
    let disposeBag = DisposeBag()

    var imagePicker = UIImagePickerController().then {
        $0.modalPresentationStyle = .overCurrentContext
    }
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.medium
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    lazy var titleLabel = UILabel().then {
        $0.text = "프로필 편집"
        $0.font = Pretendard.semiBold(18)
        $0.textColor = Gray.black
    }
    
    var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.medium, for: .normal)
        $0.titleLabel?.font = Pretendard.regular(18)
    }
    
    lazy var thumbnailView = UIImageView().then {
        $0.sd_setImage(with: viewModel.thumbnail, placeholderImage: nil, options: .scaleDownLargeImages)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = Gray.light
    }
    
    lazy var cameraButton = UIButton().then {
        $0.backgroundColor = Gray.white
        $0.setImage(UIImage(named: "Camera")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = Gray.light
        $0.layer.borderColor = Gray.light.cgColor
        $0.layer.borderWidth = 1.3
        $0.adjustsImageWhenHighlighted = false
        let albumAction = UIAction(title: "앨범에서 선택") { _ in
            self.openAlbum()
        }
        let cameraAction = UIAction(title: "카메라 촬영") { _ in
            self.openCamera()
        }
        let actionArray = [albumAction, cameraAction]
        $0.menu = UIMenu(options: .displayInline, preferredElementSize: .small, children: actionArray)
        $0.showsMenuAsPrimaryAction = true
    }
    
    var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var nicknameBorderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요"
        $0.text = viewModel.username
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
    }
    
    var introduceLabel = UILabel().then {
        $0.text = "소개글"
        $0.font = Pretendard.semiBold(17)
        $0.textColor = Gray.black
    }
    
    var introduceBorderView = UIView().then {
        $0.backgroundColor = Gray.white
        $0.layer.borderColor = Gray.semiLight.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    lazy var introduceTextField = UITextField().then {
        $0.placeholder = "소개글을 입력해주세요"
        $0.font = Pretendard.regular(18)
        $0.textColor = Gray.black
        $0.tintColor = Boarding.blue
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        imagePicker.delegate = self
        nicknameTextField.delegate = self
        introduceTextField.delegate = self
        dismissKeyboardWhenTapped()
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
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-20)
        }
        
        let divider = divider()
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        view.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        thumbnailView.rounded(axis: .horizontal)
        
        view.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.snp.bottom).offset(-44)
            make.left.equalTo(thumbnailView.snp.right).offset(-34)
            make.width.height.equalTo(36)
        }
        cameraButton.rounded(axis: .horizontal)
        
        view.addSubview(nicknameLabel)
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailView.snp.bottom).offset(44)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(nicknameBorderView)
        nicknameBorderView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.left.equalTo(nicknameLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        
        nicknameBorderView.addSubview(nicknameTextField)
        nicknameTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        view.addSubview(introduceLabel)
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameBorderView.snp.bottom).offset(28)
            make.left.equalToSuperview().offset(20)
        }
        
        view.addSubview(introduceBorderView)
        introduceBorderView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(12)
            make.left.equalTo(introduceLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
        }
        
        introduceBorderView.addSubview(introduceTextField)
        introduceTextField.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func setRx() {
        viewModel.introduce
            .bind(to: introduceTextField.rx.text)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .subscribe(onNext: {
                if self.nicknameTextField.text == "" {
                    self.toastAlert("닉네임을 입력해주세요")
                } else if self.introduceTextField.text == "" {
                    self.toastAlert("소개글을 입력해주세요")
                } else {
                    self.view.endEditing(true)
                    self.indicator.startAnimating()
                    self.view.isUserInteractionEnabled = false
                    self.editProfile()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.processCompleted
            .subscribe(onNext:{ [weak self] in
                self?.indicator.stopAnimating()
                self?.view.isUserInteractionEnabled = true
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func editProfile() {
        //프로필 이미지 바뀌었을때
        if thumbnailChanged {
            viewModel.changeThumbnail(image: thumbnailView.image)
        } else {
            viewModel.thumbnailCompleted.onNext(())
        }
        //닉네임 바뀌었을때
        if nicknameTextField.text! == viewModel.username {
            viewModel.nicknameCompleted.onNext(())
        } else {
            viewModel.changeNickname(nicknameTextField.text!)
        }
        //소개글 바뀌었을때
        if introduceTextField.text! == viewModel.introduce.value {
            viewModel.introduceCompleted.onNext(())
        } else {
            viewModel.changeIntroduce(introduceTextField.text!)
        }
    }
    
    func openCamera() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openAlbum() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nicknameTextField.resignFirstResponder()
        return true
    }
}

//MARK: - UIImagePickerControllerDelegate
extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[.originalImage] as! UIImage
        thumbnailChanged = true
        thumbnailView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
