//
//  TestViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/07.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class TestViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCaptureMovieFileOutput?
    
    var location: String = ""
    var time: String = ""
    var weather: String = ""
    
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
    
    lazy var cameraButton = UIButton().then {
        $0.setImage(UIImage(named: "Camera"), for: .normal)
        $0.addTarget(self, action:#selector(cameraButtonPressed), for: .touchUpInside)
    }
    
    @objc func cameraButtonPressed() {
        let cameraCustomVC = CameraCustomViewController()
        let vc = ChangableNavigationController(rootViewController: cameraCustomVC)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    lazy var switchButton = UIButton().then {
        $0.setImage(UIImage(named: "Switch"), for: .normal)
        $0.addTarget(self, action:#selector(switchButtonPressed), for: .touchUpInside)
    }
    
    @objc func switchButtonPressed() {
        // 현재 사용중인 카메라의 position을 확인하여 다른 카메라로 전환
        guard let captureSession = captureSession else { return }
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
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera], mediaType: AVMediaType.video, position: position)
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
        setViews()
        setRx()
        setupCaptureSession()
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
        albumButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.pickImage(self!)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectImage
            .subscribe(onNext: { image in
                print(image)
            })
            .disposed(by: disposeBag)
    }
    
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let captureSession = captureSession else { return }
        
        //카메라 전면 또는 후면 설정
        var defaultVideoDevice: AVCaptureDevice?
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = dualCameraDevice
        } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) {
            defaultVideoDevice = backCameraDevice
        } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            captureSession.addInput(input)
            
            captureOutput = AVCaptureMovieFileOutput()
            captureSession.addOutput(captureOutput!)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.insertSublayer(videoPreviewLayer!, at: 0)
            DispatchQueue.global().async {
                captureSession.startRunning()
            }
        } catch {
            print("Error setting up capture session: \(error)")
        }
    }
    
    func startRecording() {
        guard let captureOutput = captureOutput else { return }
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("story_video.mp4")
        
        captureOutput.startRecording(to: fileUrl, recordingDelegate: self)
    }
    
    func stopRecording() {
        captureOutput?.stopRecording()
    }
}

extension TestViewController: AVCaptureFileOutputRecordingDelegate {
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
//
//extension TestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        var selectedImage = UIImage()
//        let mediaType = info[.mediaType] as! NSString
//        if mediaType == "public.movie" {
//            print("movie")
//        } else {
//            print("photo")
//            selectedImage = info[.originalImage] as! UIImage
//            fetchImage(info: info)
//
//        }
//        picker.dismiss(animated: true)
//
//        //        let cameraCustomVC = CameraCustomViewController()
//        //        cameraCustomVC.image = selectedImage
//        //        let vc = ChangableNavigationController(rootViewController: cameraCustomVC)
//        //        vc.modalPresentationStyle = .overCurrentContext
//        //        vc.modalTransitionStyle = .crossDissolve
//        //        present(vc, animated: true)
//    }
//
//    func fetchImage(info: [UIImagePickerController.InfoKey : Any]) {
//        if let asset = info[.phAsset] as? PHAsset {
//            if let location = asset.location {
//                print(String(location.coordinate.latitude))
//                print(String(location.coordinate.longitude))
//
//                getPlacemarkFromCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { aa in
//                    print(aa)
//                }
//            }
//            if let unFormattedDate = asset.creationDate {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
//                let a = dateFormatter.string(from: unFormattedDate)
//                print(a)
//            }
//        }
//    }
//
//    func getPlacemarkFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        let geocoder = CLGeocoder()
//
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            if let error = error {
//                print("Reverse geocoding error: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//
//            if let placemark = placemarks?.first {
//                if let name = placemark.name {
//                    completion(name)
//                } else {
//                    completion(nil)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//    }
//}
