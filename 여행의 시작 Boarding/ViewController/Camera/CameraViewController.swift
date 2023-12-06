//
//  CameraViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/07.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class CameraViewController: UIViewController {
    
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureMovieFileOutput!
    
    let viewModel = CameraViewModel()
    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = Gray.white
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true)
    }
    
    var albumButton = UIButton().then {
        $0.setImage(UIImage(named: "Album"), for: .normal)
    }
    
    var cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "Camera"), for: .normal)
    }
    
    var switchButton = UIButton().then {
        $0.setImage(UIImage(named: "Switch"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Gray.bright
        setViews()
        setRx()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Observable.combineLatest(viewModel.selectImage, viewModel.selectLocation, viewModel.selectTime)
            .take(3)
            .subscribe(onNext: { [weak self] image, location, time in
                guard let image = image, let location = location, let time = time else { return }
                let cameraCustomVC = CameraCustomViewController()
                cameraCustomVC.image = image
                cameraCustomVC.location = location
                cameraCustomVC.time = time
                let vc = ChangableNavigationController(rootViewController: cameraCustomVC)
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.resetRelay()
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(albumButton)
        view.addSubview(cameraButton)
        view.addSubview(switchButton)
        albumButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(34)
            make.bottom.equalToSuperview().inset(58)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
        cameraButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(41)
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        switchButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-34)
            make.bottom.equalToSuperview().inset(58)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    func setRx() {
        viewModel.setupPreviewLayer(view)
        
        switchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.switchCamera()
            })
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.viewModel.takeImageByCamera()
            })
            .disposed(by: disposeBag)
        
        albumButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.pickImageByAlbum(self!)
            })
            .disposed(by: disposeBag)
    }
    
    func goSetting() {
        let alert = UIAlertController(title: "현재 카메라 사용에 대한 접근 권한이 없습니다.", message: "설정 > Boarding탭에서 접근을 활성화 할 수 있습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        let confirm = UIAlertAction(title: "설정으로 이동하기", style: .default) { _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingURL) else { return }
            UIApplication.shared.open(settingURL, options: [:])
        }
        alert.addAction(cancel)
        alert.addAction(confirm)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    func startRecording() {
        guard let captureOutput = videoOutput else { return }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("story_video.mp4")
        
        captureOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    func stopRecording() {
        videoOutput?.stopRecording()
    }
}

//MARK: - AVCaptureFileOutputRecordingDelegate
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        if let error = error {
            print("Recording error: \(error.localizedDescription)")
        } else {
            // 스토리 촬영이 끝난 후 수행할 동작
            // 예를 들어, 촬영한 동영상을 인스타그램 스토리에 업로드하는 등의 동작을 수행할 수 있습니다.
        }
    }
}

