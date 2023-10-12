//
//  WritingViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/03.
//

import UIKit
import RxSwift
import RxCocoa

class WrittingViewController: UIViewController {
    
    var feedbackGenerator: UIImpactFeedbackGenerator?
    
    var image: UIImage?
    var infoTitle = ["위치", "시간", "날씨"]
    var infoDetail = ["팔레 루아얄, 파리", "2023.09.01.  12:32", "맑음, 25°C"]
    let reviewPlaceHolder = "장소에 대한 경험을 이야기해주세요. (타인에 대한 비방, 잘못된 정보의 경우에는 협의 후 삭제조치될 수 있습니다)"
    var scoreArr = [false, false, false, false, false]
    var currentScore = BehaviorRelay<Int>(value: 0)
    var categoryArr = ["관광", "휴양", "액티비티", "맛집", "숙소", "페스티벌"]
    var selectedCategoryArr = [String]()
    
    let viewModel = WrittingViewModel()
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.dark
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var mainLabel = UILabel().then {
        $0.text = "내용작성"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(18)
    }
    
    lazy var photoView = UIImageView().then {
        $0.image = image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    var infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 1
        $0.backgroundColor = Gray.light.withAlphaComponent(0.4)
    }
    
    var titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    var titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요."
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.dark
        $0.tintColor = Gray.dark
    }
    
    var reviewLabel = UILabel().then {
        $0.text = "리뷰"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    lazy var reviewTextView = UITextView().then {
        $0.text = reviewPlaceHolder
        $0.font = Pretendard.regular(16)
        $0.textColor = Gray.light
        $0.tintColor = Gray.dark
    }
    
    var scoreLabel = UILabel().then {
        $0.text = "평점"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    var scoreStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 4
        $0.backgroundColor = Gray.white
    }
    
    var categoryLabel = UILabel().then {
        $0.text = "카테고리"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    var categoryScrollView = UIScrollView().then {
        $0.backgroundColor = Gray.white
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    var categoryStackView = UIStackView().then {
        $0.backgroundColor = Gray.white
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .equalSpacing
        $0.spacing = 8
    }
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(18)
        $0.backgroundColor = Boarding.blue
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        let vc = NFTTicketViewController()
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = Gray.white
        titleTextField.delegate = self
        reviewTextView.delegate = self
        dismissKeyboardWhenTapped()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(detectScore))
        scoreStackView.addGestureRecognizer(pan)
        setViews()
        setRx()
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func detectScore(_ recognizer: UIPanGestureRecognizer) {
        //Adjust Value
        let starWidth: CGFloat = 100
        var x = recognizer.location(in: scoreStackView).x
        x = max(0, x)
        x = min(starWidth, x)
        let score = x / starWidth * 5
        let starScore = Int(round(score))
        
        //Vibrate Feedback
        if currentScore.value != starScore {
            feedbackGenerator?.impactOccurred()
            currentScore.accept(starScore)
        }
        
        //Draw Star
        (0...4).forEach{scoreArr[$0] = $0 < starScore ? true : false}
        var index = 0
        for view in scoreStackView.arrangedSubviews {
            view.tintColor = scoreArr[index] ? Boarding.blue : Gray.light
            index += 1
        }
    }
    
    @objc func categorySelected(_ sender: UIButton) {
        let index = Int(categoryStackView.arrangedSubviews.firstIndex(of: sender)!)
        if sender.isSelected {
            let rm = selectedCategoryArr.firstIndex(of: categoryArr[index])!
            selectedCategoryArr.remove(at: rm)
        } else {
            selectedCategoryArr.append(categoryArr[index])
        }
        sender.isSelected.toggle()
        feedbackGenerator?.impactOccurred()
        print(selectedCategoryArr)
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        let navigationDivider = divider()
        view.addSubview(navigationDivider)
        navigationDivider.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.top.equalTo(navigationDivider).offset(16)
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(200)
            make.width.equalTo(150)
        }
        
        view.addSubview(infoStackView)
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(photoView)
            make.left.equalTo(photoView.snp.right).offset(9)
            make.height.equalTo(photoView)
            make.right.equalToSuperview().inset(24)
        }
        for index in 0...2 {
            let subview = UIView().then {
                $0.backgroundColor = Gray.white
            }
            let mainLabel = UILabel().then {
                $0.text = infoTitle[index]
                $0.textColor = Gray.black
                $0.font = Pretendard.semiBold(16)
            }
            let subLabel = UILabel().then {
                $0.text = infoDetail[index]
                $0.textColor = Gray.dark
                $0.font = Pretendard.regular(14)
            }
            subview.addSubview(mainLabel)
            subview.addSubview(subLabel)
            mainLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.top.equalToSuperview().offset(10)
            }
            subLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(12)
                make.bottom.equalToSuperview().inset(10)
            }
            infoStackView.addArrangedSubview(subview)
        }
        
        let photoDivider = divider()
        view.addSubview(photoDivider)
        photoDivider.snp.makeConstraints { make in
            make.top.equalTo(photoView.snp.bottom).offset(18)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(4)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(photoDivider).offset(16)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(24)
        }
        
        let titleDivider = divider()
        view.addSubview(titleDivider)
        titleDivider.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleDivider).offset(12)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(reviewTextView)
        reviewTextView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let reviewDivider = divider()
        view.addSubview(reviewDivider)
        reviewDivider.snp.makeConstraints { make in
            make.top.equalTo(reviewTextView.snp.bottom).offset(16)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewDivider).offset(20)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(scoreStackView)
        scoreStackView.snp.makeConstraints { make in
            make.centerY.equalTo(scoreLabel)
            make.height.equalTo(22)
            make.right.equalToSuperview().offset(-24)
        }
        for _ in 0...4 {
            let subview = UIImageView().then {
                let image = UIImage(named: "Star")?.withRenderingMode(.alwaysTemplate)
                $0.image = image
                $0.tintColor = Gray.light
            }
            subview.snp.makeConstraints { make in
                make.width.equalTo(23.5)
            }
            scoreStackView.addArrangedSubview(subview)
        }
        
        let scoreDivider = divider()
        view.addSubview(scoreDivider)
        scoreDivider.snp.makeConstraints { make in
            make.top.equalTo(scoreStackView.snp.bottom).offset(19)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(scoreDivider).offset(12)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(categoryScrollView)
        categoryScrollView.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(12)
            make.left.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        categoryScrollView.addSubview(categoryStackView)
        categoryStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
        for index in 0...5 {
            lazy var button = UIButton().then {
                $0.setBackgroundColor(Gray.white, for: .normal)
                $0.setBackgroundColor(Boarding.blue, for: .selected)
                $0.setTitleColor(Gray.medium, for: .normal)
                $0.setTitleColor(Gray.white, for: .selected)
                $0.setTitle(categoryArr[index], for: .normal)
                $0.titleLabel?.font = Pretendard.regular(14)
                $0.layer.masksToBounds = true
                $0.layer.cornerRadius = 16
                $0.layer.borderWidth = 1
                $0.layer.borderColor = Gray.bright.cgColor
                $0.addTarget(self, action: #selector(categorySelected), for: .touchUpInside)
            }
            button.snp.makeConstraints { make in
                make.width.equalTo((button.intrinsicContentSize.width + 24))
            }
            categoryStackView.addArrangedSubview(button)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
    }
    
    func divider() -> UIView {
        return UIView().then {
            $0.backgroundColor = Gray.light.withAlphaComponent(0.4)
        }
    }
    
    func setRx() {
        titleTextField.rx.text.orEmpty
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        reviewTextView.rx.text.orEmpty
            .bind(to: viewModel.mainText)
            .disposed(by: disposeBag)
        
        currentScore
            .bind(to: viewModel.starPoint)
            .disposed(by: disposeBag)
        
        viewModel.dataValid
            .subscribe(onNext: { bool in
                print(bool)
            })
            .disposed(by: disposeBag)
        
        
        
        completeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.NFTWrite()
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - UITextFieldDelegate
extension WrittingViewController: UITextFieldDelegate {
    
}

//MARK: - UITextViewDelegate
extension WrittingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            reviewTextView.textColor = Gray.light
            reviewTextView.text = reviewPlaceHolder
        } else if textView.text == reviewPlaceHolder {
            reviewTextView.textColor = Gray.dark
            reviewTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || textView.text == reviewPlaceHolder {
            reviewTextView.textColor = Gray.light
            reviewTextView.text = reviewPlaceHolder
        }
    }
}
