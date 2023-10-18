//
//  CameraViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/10/10.
//

import Foundation
import Photos
import CoreLocation
import RxSwift
import RxCocoa

class CameraViewModel: NSObject {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    
    let selectImage = PublishRelay<UIImage?>()
    let selectLocation = BehaviorRelay<String?>(value: nil)
    let selectTime = BehaviorRelay<String?>(value: nil)
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        self.setupCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        //카메라 전면 또는 후면 설정
        var defaultVideoDevice: AVCaptureDevice?
        if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            defaultVideoDevice = dualCameraDevice
        } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            defaultVideoDevice = backCameraDevice
        } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            captureSession.addInput(input)
            
//            videoOutput = AVCaptureMovieFileOutput()
//            captureSession.addOutput(videoOutput)
            
            photoOutput = AVCapturePhotoOutput()
            captureSession.addOutput(photoOutput)
        } catch {
            print("Error setting up capture session: \(error)")
        }
    }
    
    func setupPreviewLayer(_ view: UIView) {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
    }
    
    func resetRelay() {
        selectLocation.accept(nil)
        selectTime.accept(nil)
    }
    
    func switchCamera() {
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
    
    func takeImageByCamera() {
        let settings = AVCapturePhotoSettings()
        self.photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func pickImageByAlbum(_ viewController: UIViewController) {
        ImagePickerManager.shared.pickImage(from: viewController) { [weak self] image, location, time in
            self?.selectImage.accept(image)
            self?.selectLocation.accept(location)
            self?.selectTime.accept(time)
        }
    }
}

//MARK: - CameraManager
extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) {
            self.selectImage.accept(image)
            let locationManager = LocationManager()
            locationManager.getLocation { [weak self] location in
                self?.selectLocation.accept(location)
            }
            self.selectTime.accept(self.getTime())
        }
    }
    
    func getTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
        let time = dateFormatter.string(from: Date())
        return time
    }
}

//MARK: - LoactionManager
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getLocation(completion: @escaping (String?) -> Void) {
        if let currentLocation = locationManager.location {
            let latitude = currentLocation.coordinate.latitude
            let longitude = currentLocation.coordinate.longitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    completion("위치 정보가 없어요")
                    return
                }
                if let placemark = placemarks?.first {
                    if let name = placemark.name {
                        completion(name)
                    } else {
                        completion("위치 정보가 없어요")
                    }
                } else {
                    completion("위치 정보가 없어요")
                }
            }
        } else {
            completion("위치 정보가 없어요")
        }
    }
}

//MARK: - AlbumManager
class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = ImagePickerManager()
    var imagePicker = UIImagePickerController()
    var imagePickerSubject = PublishSubject<UIImage?>()
    var locationSubject = PublishSubject<String?>()
    var timeSubject = PublishSubject<String?>()
    
    let disposeBag = DisposeBag()
    
    func pickImage(from viewController: UIViewController, completion: @escaping (UIImage?, String?, String?) -> Void) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.modalPresentationStyle = .fullScreen
        viewController.present(imagePicker, animated: true)
        Observable.combineLatest(imagePickerSubject, locationSubject, timeSubject)
            .take(1)
            .subscribe(onNext: { image, location, time in
                guard let image = image, let location = location, let time = time else { return }
                completion(image, location, time)
            })
            .disposed(by: disposeBag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! NSString
        if mediaType == "public.movie" {
            print("movie")
        } else {
            picker.dismiss(animated: true)
            let pickedImage = info[.originalImage] as! UIImage
            imagePickerSubject.onNext(pickedImage)
            getLocation(info: info)
            getTime(info: info)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        imagePickerSubject.onNext(UIImage(named: "France1"))
    }
    
    func getLocation(info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            if let location = asset.location {
                let latitude = location.coordinate.latitude
                let longitude = location.coordinate.longitude
                getPlace(latitude, longitude) { [weak self] location in
                    self?.locationSubject.onNext(location)
                }
            } else {
                locationSubject.onNext("위치 정보가 없어요")
            }
        }
    }
    
    func getPlace(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                completion("위치 정보가 없어요")
                return
            }
            
            if let placemark = placemarks?.first {
                if let name = placemark.name {
                    completion(name)
                } else {
                    completion("위치 정보가 없어요")
                }
            } else {
                completion("위치 정보가 없어요")
            }
        }
    }
    
    func getTime(info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            if let unFormattedDate = asset.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
                let time = dateFormatter.string(from: unFormattedDate)
                timeSubject.onNext(time)
            } else {
                timeSubject.onNext("시간 정보가 없어요")
            }
        }
    }
}
