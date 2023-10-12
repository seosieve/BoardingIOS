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
    
    lazy var switchButton = UIButton().then {
        $0.setImage(UIImage(named: "Switch"), for: .normal)
        $0.addTarget(self, action:#selector(switchButtonPressed), for: .touchUpInside)
    }
    
    @objc func switchButtonPressed() {
        // 현재 사용중인 카메라의 position을 확인하여 다른 카메라로 전환
        guard let currentCameraInput = captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        var newCamera: AVCaptureDevice?
        if currentCameraInput.device.position == .back {
            newCamera = getCamera(with: .front)
        } else {
            newCamera = getCamera(with: .back)
        }
        
        guard let newCameraInput = try? AVCaptureDeviceInput(device: newCamera!) else { return }
        
        captureSession.beginConfiguration()
        captureSession.removeInput(currentCameraInput)
        captureSession.addInput(newCameraInput)
        captureSession.commitConfiguration()
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera], mediaType: .video, position: position)
        return discoverySession.devices.first
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

