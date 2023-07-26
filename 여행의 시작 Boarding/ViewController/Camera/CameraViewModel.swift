//
//  CameraViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/07/26.
//

import UIKit
import FirebaseStorage

class FirebaseStorageManager {
    static func uploadImage(image: UIImage, pathRoot: String, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child("\(imageName)")
        firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
            firebaseReference.downloadURL { url, _ in
                completion(url)
            }
        }
    }
    
    static func uploadVideo(url: URL, pathRoot: String, completion: @escaping (URL?) -> Void) {
        do {
            let videoData = try Data(contentsOf: url)
            let metaData = StorageMetadata()
            metaData.contentType = "video/mp4"
            let imageName = "\(String(Date().timeIntervalSince1970)).mp4"
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            firebaseReference.putData(videoData, metadata: metaData) { metaData, error in
                firebaseReference.downloadURL { url, _ in
                    completion(url)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }

    }
    
    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1*1024*1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    static func downloadVideo(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(1*1024*1024)
        
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
}


