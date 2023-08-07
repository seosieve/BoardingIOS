//
//  CameraViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/07/26.
//

import UIKit
import AVKit

class CameraViewController: UIViewController {

    let picker = UIImagePickerController()
    var player: AVPlayer?
    var videoURL: URL?
    
    lazy var backButton = UIButton().then {
        let image = UIImage(named: "Back")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .systemPink
        $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
    }
    
    @objc func backButtonPressed() {
        self.dismiss(animated: true)
    }
    
    lazy var pickerButton = UIButton().then {
        $0.setTitle("이미지 업로드", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
        $0.addTarget(self, action: #selector(pickerButtonPressed), for: .touchUpInside)
    }
    
    @objc func pickerButtonPressed() {
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image", "public.movie"]
        present(picker, animated: true)
    }
    
    var infoLabel = UILabel().then {
        $0.text = "aaaaa"
        $0.textAlignment = .center
    }
    
    lazy var loadImageButton = UIButton().then {
        $0.setTitle("이미지 로드", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
        $0.addTarget(self, action: #selector(loadImageButtonPressed), for: .touchUpInside)
    }
    
    @objc func loadImageButtonPressed() {
//        guard let urlString = UserDefaults.standard.string(forKey: "myImageUrl") else { return }
//        print(urlString)
//        FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
//            self?.downloadImageView.image = image
//        }
        guard let urlString = UserDefaults.standard.string(forKey: "myVideoUrl") else { return }
        videoURL = URL(string: urlString)
        loadVideoView()
    }
    
    var downloadImageView = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    var videoView = UIView().then {
        $0.backgroundColor = .green
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Gray.white
        picker.delegate = self
        setViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let player = player else { return }
        player.pause()
    }
    
    func setViews() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(pickerButton)
        pickerButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(48)
        }
        
        view.addSubview(loadImageButton)
        loadImageButton.snp.makeConstraints { make in
            make.bottom.equalTo(window.safeAreaInsets.bottom).offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(48)
        }
        
        view.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(loadImageButton.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(48)
        }
        
//        view.addSubview(downloadImageView)
//        downloadImageView.snp.makeConstraints { make in
//            make.top.equalTo(pickerButton.snp.bottom).offset(50)
//            make.centerX.equalToSuperview()
//            make.left.equalToSuperview().offset(40)
//            make.height.equalTo(400)
//        }
        
        view.addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.top.equalTo(pickerButton.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(40)
            make.height.equalTo(400)
        }
    }
    
    func loadVideoView() {
        guard let path = Bundle.main.path(forResource: "Eiffel", ofType: "mp4") else { return }
        player = AVPlayer.init(url: videoURL ?? URL(filePath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.videoView.frame
        playerLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(playerLayer)
        player!.play()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            self.player!.seek(to: .zero)
            self.player!.play()
          }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType == "public.movie" {
            guard let selectedVideoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
            FirebaseStorageManager.uploadVideo(url: selectedVideoURL, pathRoot: "aa") { url in
                if let url = url {
                    UserDefaults.standard.set(url.absoluteString, forKey: "myVideoUrl")
                }
            }
        } else {
            print("bb")
        }
        
        picker.dismiss(animated: true)
//        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//        FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: "aa") { url in
//            if let url = url {
//                UserDefaults.standard.set(url.absoluteString, forKey: "myImageUrl")
//                self.title = "이미지 업로드 완료"
//            }
//        }
//        picker.dismiss(animated: true)
    }
}
