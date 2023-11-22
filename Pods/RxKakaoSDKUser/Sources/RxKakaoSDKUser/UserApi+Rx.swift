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

import Foundation

import RxSwift

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser

/// `UserApi`의 ReactiveX 확장입니다.
///
extension UserApi: ReactiveCompatible {}

/// 카카오 로그인의 주요 기능을 제공하는 클래스입니다.
///
/// 이 클래스를 이용하여 **카카오톡 간편로그인** 또는 **카카오계정 로그인** 으로 로그인을 수행할 수 있습니다.
///
/// 카카오톡 간편로그인 예제입니다.
///
///     // 로그인 버튼 클릭
///     if (UserApi.isKakaoTalkLoginAvailable()) {
///         UserApi.shared.rx.loginWithKakaoTalk()
///             .subscribe(onNext: { (token) in
///                 print(token)
///             }, onError: { (error) in
///                 print(error)
///             })
///             .disposed(by: self.disposeBag)
///     }
///
///     // AppDelegate
///     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
///         if (AuthController.isKakaoTalkLoginUrl(url)) {
///             if AuthController.handleOpenUrl(url: url, options: options) {
///                 return true
///             }
///         }
///         ...
///     }
///
/// 카카오계정 로그인 예제입니다.
///
///     AuthApi.shared.rx.loginWithKakaoAccount()
///         .subscribe(onNext: { (token) in
///             print(token.accessToken)
///         }, onError: { (error) in
///             print(error)
///         })
///         .disposed(by: self.disposeBag)
///
/// user/me를 호출하는 간단한 예제입니다.
///
///     UserApi.shared.rx.me()
///        .subscribe(onSuccess:{ (user) in
///            print(user)
///        }, onError: { (error) in
///            print(error)
///        })
///        .disposed(by: <#Your DisposeBag#>)
///
///

// MARK: Login APIs
extension Reactive where Base: UserApi {
    
    // MARK: Login with KakaoTalk
    
    /// 카카오톡 간편로그인을 실행합니다.
    /// - note: UserApi.isKakaoTalkLoginAvailable() 메소드로 실행 가능 여부 확인이 필요합니다. 카카오톡을 실행할 수 없을 경우 loginWithKakaoAccount() 메소드로 웹 로그인을 시도할 수 있습니다.
    /// - note: launchMethod가 .UniversalLink 일 경우 카카오톡 실행 가능 여부 확인은 필수가 아닙니다.
    /// - parameters:
    ///   - launchMethod: 카카오톡 간편로그인 앱 전환 방식 선택  { CustomScheme, .UniversalLink(Default) }
    ///   - nonce: ID 토큰 재생 공격을 방지하기 위해, ID 토큰 검증 시 사용할 임의의 문자열(정해진 형식 없음)
    public func loginWithKakaoTalk(launchMethod: LaunchMethod? = .UniversalLink,
                                   channelPublicIds: [String]? = nil,
                                   serviceTerms: [String]? = nil,
                                   nonce: String? = nil) -> Observable<OAuthToken> {
        
        return AuthController.shared.rx._authorizeWithTalk(launchMethod: launchMethod,
                                                           channelPublicIds: channelPublicIds,
                                                           serviceTerms: serviceTerms,
                                                           nonce: nonce)
    }
    
    // MARK: Login with Kakao Account
    
    /// iOS 11 이상에서 제공되는 (SF/ASWeb)AuthenticationSession 을 이용하여 로그인 페이지를 띄우고 쿠키 기반 로그인을 수행합니다. 이미 사파리에에서 로그인하여 카카오계정의 쿠키가 있다면 이를 활용하여 ID/PW 입력 없이 간편하게 로그인할 수 있습니다.
    /// - parameters:
    ///   - prompts: 동의 화면 요청 시 추가 상호작용을 요청하고자 할 때 전달. [Prompt]
    ///   - loginHint: 카카오계정 로그인 페이지의 ID에 자동 입력할 이메일 또는 전화번호
    ///   - state: 카카오 로그인 과정 중 동일한 값을 유지하는 임의의 문자열(정해진 형식 없음)
    ///   - nonce: ID 토큰 재생 공격을 방지하기 위해, ID 토큰 검증 시 사용할 임의의 문자열(정해진 형식 없음)
    public func loginWithKakaoAccount(prompts : [Prompt]? = nil,
                                      loginHint: String? = nil,
                                      nonce: String? = nil) -> Observable<OAuthToken> {
        return AuthController.shared.rx._authorizeWithAuthenticationSession(prompts: prompts,
                                                                            loginHint:loginHint,
                                                                            nonce: nonce)
    }
    
    // MARK: New Agreement
    
    /// 사용자로부터 카카오가 보유중인 사용자 정보 제공에 대한 동의를 받습니다.
    ///
    /// 카카오로부터 사용자의 정보를 제공 받거나 카카오서비스 접근권한이 필요한 경우, 사용자로부터 해당 정보 제공에 대한 동의를 받지 않았다면 이 메소드를 사용하여 **추가 항목 동의**를 받아야 합니다.
    /// 필요한 동의항목과 매칭되는 scope id를 배열에 담아 파라미터로 전달해야 합니다. 동의항목과 scope id는 카카오 디벨로퍼스의 [내 애플리케이션] > [제품 설정] > [카카오 로그인] > [동의항목]에서 확인할 수 있습니다.
    ///
    /// ## 사용자 동의 획득 시나리오
    /// 간편로그인 또는 웹 로그인을 수행하면 최초 로그인 시 카카오 디벨로퍼스에 설정된 동의항목 설정에 따라 사용자의 동의를 받습니다. 동의항목을 설정해도 상황에 따라 동의를 받지 못할 수 있습니다. 대표적인 케이스는 아래와 같습니다.
    /// - **선택 동의** 로 설정된 동의항목이 최초 로그인시 선택받지 못한 경우
    /// - **필수 동의** 로 설정하였지만 해당 정보가 로그인 시점에 존재하지 않아 카카오에서 동의항목을 보여주지 못한 경우
    /// - 사용자가 해당 동의항목이 설정되기 이전에 로그인한 경우
    ///
    /// 이외에도 다양한 여건에 따라 동의받지 못한 항목이 발생할 수 있습니다.
    ///
    /// ## 추가 항목 동의 받기 시 주의사항
    /// **선택 동의** 으로 설정된 동의항목에 대한 **추가 항목 동의 받기**는, 반드시 **사용자가 동의를 거부하더라도 서비스 이용이 지장이 없는** 시나리오에서 요청해야 합니다.
    public func loginWithKakaoAccount(scopes:[String],nonce: String? = nil) -> Observable<OAuthToken> {
        return AuthController.shared.rx._authorizeByAgtWithAuthenticationSession(scopes:scopes, nonce:nonce)
    }
    
#if swift(>=5.8)
    @_documentation(visibility: private)
#endif
    /// 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func loginWithKakaoAccount(prompts : [Prompt]? = nil,
                                      channelPublicIds: [String]? = nil,
                                      serviceTerms: [String]? = nil,
                                      nonce: String? = nil) -> Observable<OAuthToken> {
        
        return AuthController.shared.rx._authorizeWithAuthenticationSession(prompts: prompts,
                                                                            channelPublicIds: channelPublicIds,
                                                                            serviceTerms: serviceTerms,
                                                                            nonce: nonce)
    }
}

// MARK: Other APIs
extension Reactive where Base: UserApi {
    /// 앱 연결 상태가 **PREREGISTER** 상태의 사용자에 대하여 앱 연결 요청을 합니다. **자동연결** 설정을 비활성화한 앱에서 사용합니다. 요청에 성공하면 회원번호가 반환됩니다.
    public func signup(properties: [String:String]? = nil) -> Single<Int64?> {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:Paths.signup), parameters:["properties": properties?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> Int64? in
                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                    return json["id"] as? Int64
                }
                else {
                    return nil
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 사용자에 대한 다양한 정보를 얻을 수 있습니다.
    /// ## SeeAlso
    /// - ``User``
    public func me(propertyKeys: [String]? = nil,
                   secureResource: Bool = true) -> Single<User> {        
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userMe),
                                    parameters: ["property_keys": propertyKeys?.toJsonString(), "secure_resource": secureResource].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// User 클래스에서 제공되고 있는 사용자의 부가정보를 신규저장 및 수정할 수 있습니다.
    ///
    /// 저장 가능한 키 이름은 개발자 사이트의 [내 애플리케이션]  > [제품 설정] >  [카카오 로그인] > [사용자 프로퍼티] 메뉴에서 확인하실 수 있습니다. 앱 연결 시 기본 저장되는 nickanme, profile_image, thumbnail_image 값도 덮어쓰기 가능하며
    /// 새로운 컬럼을 추가하면 해당 키 이름으로 값을 저장할 수 있습니다.
    /// ## SeeAlso
    /// - ``User.properties``
    public func updateProfile(properties: [String:Any]) -> Completable {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:Paths.userUpdateProfile),
                                 parameters: ["properties": properties.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .do (
                onNext: { _ in
                    SdkLog.i("completable:\n success\n\n" )
                }
            )
            .ignoreElements()
            .asCompletable()
    }
    
    /// 현재 토큰의 기본적인 정보를 조회합니다. me()에서 제공되는 다양한 사용자 정보 없이 가볍게 토큰의 유효성을 체크하는 용도로 사용하는 경우 추천합니다.
    /// ## SeeAlso
    /// - ``AccessTokenInfo``
    public func accessTokenInfo() -> Single<AccessTokenInfo> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userAccessTokenInfo))
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 토큰을 강제로 만료시킵니다. 같은 사용자가 여러개의 토큰을 발급 받은 경우 로그아웃 요청에 사용된 토큰만 만료됩니다.
    public func logout() -> Completable {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:Paths.userLogout))
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .ignoreElements()
            .asCompletable()
            .do(onError: { (_) in
                ///실패여부와 상관없이 토큰삭제.
                AUTH.tokenManager.deleteToken()
            }, onCompleted:{
                ///실패여부와 상관없이 토큰삭제.
                AUTH.tokenManager.deleteToken()
            })
    }
    
    /// 카카오 플랫폼 서비스와 앱 연결을 해제합니다.
    public func unlink() -> Completable {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:Paths.userUnlink))
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .ignoreElements()
            .asCompletable()
            .do(onCompleted: {
                AUTH.tokenManager.deleteToken()
            })
    }
    
    /// 앱에 가입한 사용자의 배송지 정보를 얻을 수 있습니다.
    /// ## SeeAlso
    /// - ``UserShippingAddresses``
    public func shippingAddresses(fromUpdatedAt: Date? = nil, pageSize: Int? = nil) -> Single<UserShippingAddresses> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userShippingAddress),
                                    parameters: ["from_updated_at": fromUpdatedAt?.toSeconds(), "page_size": pageSize].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customSecondsSince1970, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 앱에 가입한 사용자의 배송지 정보를 얻을 수 있습니다.
    /// ## SeeAlso
    /// - ``UserShippingAddresses``
    public func shippingAddresses(addressId: Int64) -> Single<UserShippingAddresses> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userShippingAddress),
                                 parameters: ["address_id": addressId].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customSecondsSince1970, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 사용자가 카카오 간편가입을 통해 동의한 서비스 약관 내역을 반환합니다.
    /// ## SeeAlso
    /// - ``UserServiceTerms``
    /// - parameters:
    ///     - result: app_service_terms를 지정해 앱에 사용 설정된 서비스 약관 목록 요청
    ///     - tags: 조회할 서비스 약관에 설정된 tag 목록
    public func serviceTerms(result:String? = nil, tags: [String]? = nil) -> Single<UserServiceTerms> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userServiceTerms),
                                        parameters: ["result": result, "tags": tags?.joined(separator: ",")].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 특정 서비스 약관에 대한 동의를 철회하고, 동의 철회가 반영된 서비스 약관 목록 반환합니다.
    /// - parameters:
    ///     - tags: 조회할 서비스 약관에 설정된 tag 목록
    public func revokeServiceTerms(tags: [String]) -> Single<UserRevokedServiceTerms> {
        return AUTH_API.rx.responseData(.post, Urls.compose(path: Paths.userRevokeServiceTerms), parameters: ["tags" : tags.joined(separator: ",")].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map { (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            }
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 사용자가 동의한 동의 항목의 상세 정보 목록을 조회합니다.
    /// [내 애플리케이션] > [카카오 로그인] > [동의 항목]에 설정된 동의 항목의 목록과 사용자의 동의 여부를 반환합니다.
    /// - parameters:
    ///   - scopes: 추가할 동의 항목 ID 목록 (옵셔널)
    public func scopes(scopes:[String]? = nil) -> Single<ScopeInfo> {
        return AUTH_API.rx.responseData(.get, Urls.compose(path:Paths.userScopes), parameters: ["scopes":scopes?.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 사용자의 특정 동의 항목에 대한 동의를 철회(Revoke)합니다.
    /// 동의 내역 확인하기 API를 통해 조회한 동의 항목 정보 중 동의 철회 가능 여부(revocable) 값이 true인 동의 항목만 철회 가능합니다.
    /// - parameters:
    ///   - scopes: 추가할 동의 항목 ID 목록
    public func revokeScopes(scopes:[String]) -> Single<ScopeInfo> {
        return AUTH_API.rx.responseData(.post, Urls.compose(path:Paths.userRevokeScopes), parameters: ["scopes":scopes.toJsonString()].filterNil())
            .compose(AUTH_API.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
}
