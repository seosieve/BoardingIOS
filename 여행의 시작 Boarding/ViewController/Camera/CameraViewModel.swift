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

class CameraViewModel {
    let selectImage = BehaviorRelay<UIImage?>(value: nil)
    
    func pickImage(_ viewController: UIViewController) {
        ImagePickerManager.shared.pickImage(from: viewController) { [weak self] image in
            self?.selectImage.accept(image)
        }
    }
}

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = ImagePickerManager()
    var imagePicker = UIImagePickerController()
    var imagePickerSubject = PublishSubject<UIImage?>()
    var locationSubject = PublishSubject<St?>()
    
    let disposeBag = DisposeBag()
    
    func pickImage(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        imagePicker.modalPresentationStyle = .fullScreen
        viewController.present(imagePicker, animated: true)
        
        imagePickerSubject
            .take(1)
            .subscribe(onNext: { image in
                completion(image)
            })
            .disposed(by: disposeBag)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[.mediaType] as! NSString
        if mediaType == "public.movie" {
            print("movie")
        } else {
            let pickedImage = info[.originalImage] as! UIImage
            imagePickerSubject.onNext(pickedImage)
            
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerSubject.onNext(nil)
        picker.dismiss(animated: true)
    }
    
    func fetchImage(info: [UIImagePickerController.InfoKey : Any]) {
        if let asset = info[.phAsset] as? PHAsset {
            if let location = asset.location {
                print(String(location.coordinate.latitude))
                print(String(location.coordinate.longitude))
                
//                getPlacemarkFromCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude) { aa in
//                    print(aa)
//                }
            }
            if let unFormattedDate = asset.creationDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
                let a = dateFormatter.string(from: unFormattedDate)
                print(a)
            }
        }
    }
}
