//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit
import RxSwift

import SafariServices
import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth

import RxKakaoSDKCommon

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@available(iOSApplicationExtension, unavailable)
let AUTH_CONTROLLER = AuthController.shared

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@available(iOSApplicationExtension, unavailable)
extension AuthController: ReactiveCompatible {}

#if swift(>=5.8)
@_documentation(visibility: private)
#endif
@available(iOSApplicationExtension, unavailable)
extension Reactive where Base: AuthController {

    // MARK: Login with KakaoTalk
    
    
    public func _authorizeWithTalk(launchMethod: LaunchMethod? = nil,
                                  channelPublicIds: [String]? = nil,
                                  serviceTerms: [String]? = nil,
                                  nonce: String? = nil) -> Observable<OAuthToken> {
        return Observable<String>.create { observer in
            AUTH_CONTROLLER.authorizeWithTalkCompletionHandler = { (callbackUrl) in
                let parseResult = callbackUrl.oauthResult()
                if let code = parseResult.code {
                    observer.onNext(code)
                } else {
                    let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                    SdkLog.e("Failed to parse redirect URI.")
                    observer.onError(error)
                }
            }
            
            let parameters = AUTH_CONTROLLER.makeParametersForTalk(channelPublicIds:channelPublicIds,
                                                                   serviceTerms:serviceTerms,
                                                                   nonce: nonce)

            guard let url = SdkUtils.makeUrlWithParameters(url:Urls.compose(.TalkAuth, path:Paths.authTalk),
                                                           parameters: parameters,
                                                           launchMethod: launchMethod) else {
                SdkLog.e("Bad Parameter - make URL error")
                observer.onError(SdkError(reason: .BadParameter))
                return Disposables.create()
            }
            
            UIApplication.shared.open(url, options: [:]) { (result) in
                if (result) {
                    SdkLog.d("카카오톡 실행: \(url.absoluteString)")
                }
                else {
                    SdkLog.e("카카오톡 실행 취소")
                    observer.onError(SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."))
                    return
                }
            }
            
            return Disposables.create()
        }
        .flatMap { code in
            AuthApi.shared.rx.token(code: code, codeVerifier: AUTH_CONTROLLER.codeVerifier).asObservable()
        }
    }
    
    /// **카카오톡 간편로그인** 등 외부로부터 리다이렉트 된 코드요청 결과를 처리합니다.
    /// AppDelegate의 openURL 메소드 내에 다음과 같이 구현해야 합니다.
    ///
    /// ```
    /// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ///     if (AuthController.isKakaoTalkLoginUrl(url)) {
    ///         if AuthController.rx.handleOpenUrl(url: url, options: options) {
    ///             return true
    ///         }
    ///     }
    ///
    ///     // 서비스의 나머지 URL 핸들링 처리
    /// }
    ///
    public static func handleOpenUrl(url:URL,  options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthController.isValidRedirectUri(url)) {
            if let authorizeWithTalkCompletionHandler = AUTH_CONTROLLER.authorizeWithTalkCompletionHandler {
                authorizeWithTalkCompletionHandler(url)
            }
        }
        return false
    }    
    
    // MARK: New Agreement
    
    public func _authorizeByAgtWithAuthenticationSession(scopes:[String],
                                                         state: String? = nil,
                                                         nonce: String? = nil) -> Observable<OAuthToken> {
        return AuthApi.shared.rx.agt().asObservable().flatMap({ agtToken -> Observable<OAuthToken> in
            return _authorizeWithAuthenticationSession(state:state, agtToken: agtToken, scopes: scopes, nonce:nonce).flatMap({ oauthToken in
                return Observable<OAuthToken>.create { observer in
                    if let topVC = UIApplication.getMostTopViewController() {
                        let topVCName = "\(type(of: topVC))"
                        SdkLog.d("rx top vc: \(topVCName)")
    
                        if topVCName == "SFAuthenticationViewController" {
                            DispatchQueue.main.asyncAfter(deadline: .now() + AuthController.delayForAuthenticationSession) {
                                if let topVC1 = UIApplication.getMostTopViewController() {
                                    let topVCName1 = "\(type(of: topVC1))"
                                    SdkLog.d("rx top vc: \(topVCName1)")
                                }
                                observer.onNext(oauthToken)
                            }
                        }
                        else {
                            SdkLog.d("rx top vc: \(topVCName)")
                            observer.onNext(oauthToken)
                        }
                    }                    
                    return Disposables.create()
                }
            })
        })
    }
  
    
    public func _authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                    state: String? = nil,
                                                    agtToken: String? = nil,
                                                    scopes:[String]? = nil,
                                                    channelPublicIds: [String]? = nil,
                                                    serviceTerms: [String]? = nil,
                                                    loginHint: String? = nil,
                                                    accountParameters: [String:String]? = nil,
                                                    nonce: String? = nil,
                                                    accountsSkipIntro: Bool? = nil,
                                                    accountsTalkLoginVisible: Bool? = nil) -> Observable<OAuthToken> {
        return Observable<String>.create { observer in
            let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
                (callbackUrl:URL?, error:Error?) in
                
                guard let callbackUrl = callbackUrl else {
                    if let error = error as? ASWebAuthenticationSessionError {
                        if error.code == ASWebAuthenticationSessionError.canceledLogin {
                            SdkLog.e("The authentication session has been canceled by user.")
                            observer.onError(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        } else {
                            SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                            observer.onError(SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        }
                    }
                    else {
                        SdkLog.e("An unknown authentication session error occurred.")
                        observer.onError(SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    }
                    return
                }
                print("callbackUrl: \(callbackUrl)")
                let parseResult = callbackUrl.oauthResult()
                if let code = parseResult.code {
                    SdkLog.i("code:\n \(String(describing: code))\n\n" )
                    observer.onNext(code)
                } else {
                    let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                    SdkLog.e("Failed to parse redirect URI.")
                    observer.onError(error)
                }
            }
            
            var parameters = AUTH_CONTROLLER.makeParameters(prompts: prompts,
                                                            state: state,
                                                            agtToken: agtToken,
                                                            scopes: scopes,
                                                            channelPublicIds: channelPublicIds,
                                                            serviceTerms: serviceTerms,
                                                            loginHint: loginHint,
                                                            nonce: nonce,
                                                            accountsSkipIntro: accountsSkipIntro,
                                                            accountsTalkLoginVisible: accountsTalkLoginVisible)
            
            var url: URL? = nil
            if let accountParameters = accountParameters, !accountParameters.isEmpty {
                for (key, value) in accountParameters {
                    parameters[key] = value
                }
                
                url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:Paths.kakaoAccountsLogin), parameters:parameters)
            }
            else {
                url = SdkUtils.makeUrlWithParameters(Urls.compose(.Kauth, path:Paths.authAuthorize), parameters:parameters)
            }            
            
            if let url = url {
                SdkLog.d("\n===================================================================================================")
                SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
                
                let authenticationSession = ASWebAuthenticationSession(url: url,
                                                                       callbackURLScheme: (try! KakaoSDK.shared.scheme()),
                                                                       completionHandler:authenticationSessionCompletionHandler)
                
                authenticationSession.presentationContextProvider = AUTH_CONTROLLER.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                if agtToken != nil {
                    authenticationSession.prefersEphemeralWebBrowserSession = true
                }
                
                AUTH_CONTROLLER.authenticationSession = authenticationSession
                AUTH_CONTROLLER.authenticationSession?.start()
            }
            return Disposables.create()
        }
        .flatMap { code in
            AuthApi.shared.rx.token(code: code, codeVerifier: AUTH_CONTROLLER.codeVerifier).asObservable()
        }        
    }
}
