//
//  TabBarViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    let picker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTabBar()
    }
    
    func setUpTabBar() {
        // Set CustomTabBar
        let customTabBar = CustomTabBar()
        customTabBar.centerButtonActionHandler = {
            self.cameraButtonPressed()
        }
        customTabBar.tabbarColor = Gray.white
        customTabBar.tabBarItemColor = Boarding.blue
        customTabBar.unselectedItemColor = Gray.light
        customTabBar.buttonImage = UIImage(named: "Plus")
        setValue(customTabBar, forKey: "tabBar")
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: Pretendard.regular(12)], for: .normal)
        
        // ViewController Connect
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.image = UIImage(named: "Home")
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -5, vertical: 0)
        
        let planVC = UINavigationController(rootViewController: PlanViewController())
        planVC.tabBarItem.image = UIImage(named: "Plan")
        planVC.tabBarItem.title = "플랜"
        planVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        
        let recordVC = UINavigationController(rootViewController: RecordViewController())
        recordVC.tabBarItem.image = UIImage(named: "Record")
        recordVC.tabBarItem.title = "기록"
        recordVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 30, vertical: 0)
        
        let myPageVC = UINavigationController(rootViewController: MyPageViewController())
        myPageVC.tabBarItem.image = UIImage(named: "MyPage")
        myPageVC.tabBarItem.title = "마이페이지"
        myPageVC.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        
        setViewControllers([homeVC, planVC, recordVC, myPageVC], animated: true)
    }
    
    func cameraButtonPressed() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
}
