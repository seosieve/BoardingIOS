//
//  CameraCustomViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/10.
//

import UIKit

class CameraCustomViewController: UIViewController {
    
    var url: URL?
    var image: UIImage?
    var location: (String, String, String, Double, Double)?
    var time: String?
    
    private var currentStatusBarStyle: UIStatusBarStyle = .lightContent
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return currentStatusBarStyle
    }
    
    var customImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
    
    lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Gray.white, for: .normal)
        $0.titleLabel?.font = Pretendard.semiBold(17)
        $0.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
    }
    
    @objc func completeButtonPressed() {
        let vc = WrittingViewController()
        vc.infoArr = [location!.0, time!, "맑음, \(Int.random(in: -4..<12))°C"]
        vc.country = location!.1
        vc.city = location!.2
        vc.latitude = location!.3
        vc.longitude = location!.4
        vc.url = url
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Gray.black
        setViews()
        
        let resizeImage = resizeImage(image: image!, targetSize: CGSize(width: 100, height: 100))
        detectBrightnessAsync(image: resizeImage, upperPartRatio: 0.3) { brightness in
            print(brightness)
            if brightness == "Light" {
                self.backButton.tintColor = Gray.black
                self.completeButton.setTitleColor(Gray.black, for: .normal)
                self.currentStatusBarStyle = .darkContent
            } else {
                self.backButton.tintColor = Gray.white
                self.completeButton.setTitleColor(Gray.white, for: .normal)
                self.currentStatusBarStyle = .lightContent
            }
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }
    }
    
    func setViews() {
        view.addSubview(customImageView)
        customImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        customImageView.image = image
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(window.safeAreaInsets.top)
            make.left.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(48)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.right.equalToSuperview().offset(-19)
        }
    }
    
    func detectBrightnessAsync(image: UIImage, upperPartRatio: CGFloat, completion: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            let result = self.detectBrightness(image: image, upperPartRatio: upperPartRatio)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func detectBrightness(image: UIImage, upperPartRatio: CGFloat) -> String {
        guard let cgImage = image.cgImage else { return "Unable to get CGImage from the image" }
        
        let width = cgImage.width
        let height = cgImage.height
        // 윗부분의 높이 계산
        let upperPartHeight = Int(CGFloat(height) * upperPartRatio)
        // 이미지의 일부를 추출하여 새로운 UIImage 생성
        let croppedImage = image.crop(to: CGRect(x: 0, y: 0, width: width, height: upperPartHeight))
        // 추출한 이미지에 대해서만 색상 분석 수행
        return detect(image: croppedImage)
    }
    
    func detect(image: UIImage) -> String {
        guard let cgImage = image.cgImage else { return "Unable to get CGImage from the image" }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let pixelData = cgImage.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var totalBrightness: CGFloat = 0.0
        var pixelCount: Int = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelInfo: Int = ((width * y) + x) * 4 // 각 픽셀당 4바이트 (R, G, B, A)
                let r = CGFloat(data[pixelInfo]) / 255.0
                let g = CGFloat(data[pixelInfo + 1]) / 255.0
                let b = CGFloat(data[pixelInfo + 2]) / 255.0
                
                let brightness = (r + g + b) / 3.0 // 각 색상의 밝기 계산
                
                totalBrightness += brightness
                pixelCount += 1
            }
        }
        
        let averageBrightness = totalBrightness / CGFloat(pixelCount)
        
        if averageBrightness > 0.5 {
            return "Light"
        } else {
            return "Dark"
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
