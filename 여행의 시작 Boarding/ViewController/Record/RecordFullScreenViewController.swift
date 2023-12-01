//
//  RecordFullScreenViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class RecordFullScreenViewController: UIViewController {

    var byScrapVC = false
    
    var url = URL(string: "")
    var NFTResult = NFT.dummyType
    
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    lazy var fullScreenImageView = UIImageView().then {
        $0.sd_setImage(with: url, placeholderImage: UIImage())
        $0.backgroundColor = Gray.light
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "Back"), for: .normal)
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        if byScrapVC {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    lazy var bottomGradientView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 400)
        $0.gradient([.clear, .black.withAlphaComponent(0.9)], axis: .vertical)
    }
    
    lazy var textContainerButton = UIButton()
    
    lazy var titleLabel = UILabel().then {
        $0.text = NFTResult.title
        $0.font = Pretendard.semiBold(19)
        $0.textColor = Gray.white
    }
    
    lazy var contentLabel = UILabel().then {
        $0.text = NFTResult.content
        $0.font = Pretendard.regular(15)
        $0.textColor = Gray.white
        $0.numberOfLines = 0
        $0.lineBreakMode = .byTruncatingTail
        let attString = NSMutableAttributedString(string: $0.text!)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        attString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, attString.length))
        $0.attributedText = attString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = byScrapVC ? false : true
        setViews()
        setRx()
    }
    
    func setViews() {
        view.addSubview(fullScreenImageView)
        fullScreenImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(bottomGradientView)
        bottomGradientView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(400)
        }
        
        view.addSubview(textContainerButton)
        textContainerButton.snp.makeConstraints { make in
            make.left.centerX.bottom.equalToSuperview()
            make.height.equalTo(200)
        }
        
        textContainerButton.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-60)
            make.height.lessThanOrEqualTo(88)
        }
        
        textContainerButton.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contentLabel.snp.top).offset(-8)
        }
    }
    
    func setRx() {
        textContainerButton.rx.tap
            .subscribe(onNext: {
                if !self.byScrapVC {
                    let vc = RecordInfoViewController()
                    vc.url = self.url
                    vc.NFTResult = self.NFTResult
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
