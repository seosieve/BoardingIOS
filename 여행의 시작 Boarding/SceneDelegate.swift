//
//  SceneDelegate.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/06/02.
//

import UIKit
import RxSwift
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func setWindow(_ target: UIViewController) {
        window?.rootViewController = target
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let homeVC = TabBarViewController()
        let startVC = UINavigationController(rootViewController: StartViewController())
        
        let disposeBag = DisposeBag()
        
        window?.rootViewController = homeVC
        window?.makeKeyAndVisible()
        
//        if AuthApi.hasToken() {
//            UserApi.shared.rx.accessTokenInfo()
//                .subscribe(onSuccess:{ _ in
//                    //토큰도 있고, 토큰에 에러도 없는 상태 - 홈화면으로 이동
////                    self.setWindow(homeVC)
//                    print("aa")
//                }, onFailure: { error in
//                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
//                        //토큰이 있지만, 토큰에 유효성 에러가 있는 상태 - 로그인으로 이동
//                        self.setWindow(startVC)
//                    } else {
//                        //토큰이 있지만, 토큰에 다른 에러가 있는 상태 - 로그인으로 이동
//                        self.setWindow(startVC)
//                        print("Error: \(error)")
//                    }
//                })
//                .disposed(by: disposeBag)
//        } else {
//            //토큰이 없는 상태 - 로그인으로 이동
//            self.setWindow(startVC)
//        }
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

