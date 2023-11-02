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
    var infoDetail = ["", "", "맑음, 25°C"]
    var scoreArr = [false, false, false, false, false]
    var selectedCategoryArr = [String]()
    
    var titleResult = BehaviorRelay<String>(value: "제목을 입력해주세요.")
    var contentResult = BehaviorRelay<String>(value: "내용을 입력해주세요.")
    var starPointResult = BehaviorRelay<Int>(value: 0)
    var categoryResult = BehaviorRelay<[String]>(value: [])
    var NFTResult = NFT.dummyType
    
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
    
    var titleTextLabel = UILabel().then {
        $0.text = "제목을 입력해주세요."
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.light
    }
    
    var contentLabel = UILabel().then {
        $0.text = "내용"
        $0.textColor = Gray.black
        $0.font = Pretendard.semiBold(16)
    }
    
    var contentTextLabel = UILabel().then {
        $0.text = "내용을 입력해주세요."
        $0.font = Pretendard.regular(17)
        $0.textColor = Gray.light
        $0.numberOfLines = 0
    }
    
    lazy var tapRecognizerView = UIView().then {
        $0.backgroundColor = .clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        $0.addGestureRecognizer(tap)
    }
    
    @objc func tapRecognized() {
        let vc = WrittingTitleViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    var completeButton = UIButton().then {
        $0.setBackgroundColor(Boarding.blue, for: .normal)
        $0.setBackgroundColor(Gray.light.withAlphaComponent(0.7), for: .disabled)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.setTitleColor(Gray.dark, for: .disabled)
        $0.titleLabel?.font = Pretendard.medium(19)
        $0.isEnabled = false
    }
    
    var indicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.color = Gray.light
    }
    
    var uploadProgressView = UIProgressView().then {
        $0.trackTintColor = Gray.light
        $0.progressTintColor = Boarding.blue
        $0.progress = 0
        $0.isHidden = true
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
        feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(detectScore))
        scoreStackView.addGestureRecognizer(pan)
        setViews()
        setRx()
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
        if starPointResult.value != starScore {
            feedbackGenerator?.impactOccurred()
            starPointResult.accept(starScore)
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
        sender.isSelected.toggle()
        feedbackGenerator?.impactOccurred()
        print()
        categoryResult.accept(selectedCategoryArr)
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
        
        view.addSubview(titleTextLabel)
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.left.equalToSuperview().offset(24)
        }
        
        let titleDivider = divider()
        view.addSubview(titleDivider)
        titleDivider.snp.makeConstraints { make in
            make.top.equalTo(titleTextLabel.snp.bottom).offset(16)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleDivider).offset(12)
            make.left.equalToSuperview().offset(24)
        }
        
        view.addSubview(contentTextLabel)
        contentTextLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        let contentDivider = divider()
        view.addSubview(contentDivider)
        contentDivider.snp.makeConstraints { make in
            make.top.equalTo(contentTextLabel.snp.bottom).offset(16)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(tapRecognizerView)
        tapRecognizerView.snp.makeConstraints { make in
            make.top.equalTo(photoDivider)
            make.centerX.left.equalToSuperview()
            make.bottom.equalTo(contentDivider.snp.bottom)
        }
        
        view.addSubview(scoreLabel)
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(contentDivider).offset(20)
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
        for index in 0..<Category.count {
            lazy var button = UIButton().then {
                $0.setBackgroundColor(Gray.white, for: .normal)
                $0.setBackgroundColor(Boarding.blue, for: .selected)
                $0.setTitleColor(Gray.medium, for: .normal)
                $0.setTitleColor(Gray.white, for: .selected)
                $0.setTitle(Category.name[index], for: .normal)
                $0.titleLabel?.font = Pretendard.medium(15)
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
            make.left.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(30)
        }
        completeButton.rounded(axis: .horizontal)
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        view.addSubview(uploadProgressView)
        uploadProgressView.snp.makeConstraints { make in
            make.top.equalTo(completeButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(40)
        }
    }
    
    func setRx() {
        Observable.combineLatest(viewModel.location, viewModel.time, viewModel.weather, viewModel.title, viewModel.content, viewModel.starPoint, viewModel.category)
            .subscribe(onNext: { a,b,c,d,e,f,g in
                print(a,b,c,d,e,f,g)
            })
            .disposed(by: disposeBag)
        
        viewModel.location.accept(infoDetail[0])
        viewModel.time.accept(infoDetail[1])
        viewModel.weather.accept(infoDetail[2])
        
        titleResult
            .bind(to: titleTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        titleResult
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        contentResult
            .bind(to: contentTextLabel.rx.text)
            .disposed(by: disposeBag)
        
        contentResult
            .bind(to: viewModel.content)
            .disposed(by: disposeBag)
        
        starPointResult
            .bind(to: viewModel.starPoint)
            .disposed(by: disposeBag)
        
        categoryResult
            .bind(to: viewModel.category)
            .disposed(by: disposeBag)
        
        viewModel.dataValid
            .bind(to: completeButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.uploadProgress
            .bind(to: uploadProgressView.rx.progress)
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.completeButton.isEnabled = false
                self?.uploadProgressView.isHidden = false
                self?.indicator.startAnimating()
                self?.viewModel.NFTWrite(image: self?.image)
            })
            .disposed(by: disposeBag)
        
        viewModel.NFTResult
            .subscribe(onNext: { [weak self] NFT in
                self?.NFTResult = NFT
            })
            .disposed(by: disposeBag)
        
        
        viewModel.writtingResult
            .subscribe(onNext:{ [weak self] result in
                if result {
                    self?.indicator.stopAnimating()
                    self?.uploadProgressView.isHidden = true
                    let vc = NFTTicketViewController()
                    vc.image = self?.image
                    vc.NFTResult = self!.NFTResult
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self?.indicator.stopAnimating()
                    self?.uploadProgressView.isHidden = true
                    self?.writtingErrorAlert()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func writtingErrorAlert() {
        let alert = UIAlertController(title: "글 저장 중 에러가 발생했어요.", message: "다시 시도해주세요", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        confirm.setValue(Boarding.blue, forKey: "titleTextColor")
        alert.view.tintColor = Gray.dark
        present(alert, animated: true, completion: nil)
    }
}
