//
//  CustomImagePicker.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/08/07.
//

import UIKit

class CustomImagePicker: UIImagePickerController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = UIColor.green
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor :     UIColor.green], for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = .red
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UINavigationBar.appearance().tintColor = UIColor.green // your color
        UIBarButtonItem.appearance().setTitleTextAttributes(nil, for: .normal)
        super.viewWillDisappear(animated)
    }
}
