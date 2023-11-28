//
//  RecordInfoPageViewController.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/11/27.
//

import UIKit

class RecordInfoPageViewController: UIPageViewController {
    
    var NFT: NFT?
    
    lazy var pageList: [UIViewController] = {
        let firstPageVC = LocationInfoViewController()
        firstPageVC.NFTResult = NFT!
        let secondPageVC = UserInfoViewController()
        let thirdPageVC = NFTInfoViewController()
        thirdPageVC.NFTResult = NFT!
        return [firstPageVC, secondPageVC, thirdPageVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        if let firstVC = pageList.first {
            setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    
    func moveFromIndex(index: Int, forward: Bool = true) {
        if forward {
            self.setViewControllers([pageList[index]], direction: .forward, animated: true, completion: nil)
        } else {
            self.setViewControllers([pageList[index]], direction: .reverse, animated: true, completion: nil)
        }
    }
}

extension RecordInfoPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageList.firstIndex(of: viewController) else { return nil }
        let prevIndex = vcIndex-1
        
        guard prevIndex >= 0 else {
            return nil
        }
        guard pageList.count > prevIndex else { return nil }
        return pageList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = pageList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        
        guard nextIndex < pageList.count else {
            return nil
        }
        guard pageList.count > nextIndex else { return nil }
        return pageList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let parentVC = self.parent as? RecordInfoViewController
        var tag: Int
        if completed {
            switch viewControllers?.first {
            case is LocationInfoViewController :
                tag = 0
            case is UserInfoViewController:
                tag = 1
            default:
                tag = 2
            }
            parentVC?.buttonMotion(tag: tag)
        }
    }
}
