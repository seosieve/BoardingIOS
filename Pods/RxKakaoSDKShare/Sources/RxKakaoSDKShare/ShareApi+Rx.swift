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
import UIKit
import RxSwift

import KakaoSDKCommon
import RxKakaoSDKCommon

import KakaoSDKShare
import KakaoSDKTemplate

extension ShareApi: ReactiveCompatible {}

/// `ShareApi`의 ReactiveX 확장입니다.
///
extension Reactive where Base: ShareApi {
    
    // MARK: Fields
    
    /// 템플릿 조회 API 응답을 카카오톡 공유 URL로 변환합니다.
    /// ## SeeAlso
    /// - ``SharingResult``
    public func createSharingResultComposeTransformer(targetAppKey:String? = nil) -> ComposeTransformer<(ValidationResult, [String:Any]?), SharingResult> {
        return ComposeTransformer<(ValidationResult, [String:Any]?), SharingResult> { (observable) in
            
            return observable.flatMap { (validationResult, serverCallbackArgs) -> Observable<SharingResult> in
                SdkLog.d("--------------------------------- validationResult \(validationResult)")
                
                return Observable<SharingResult>.create { (observer) in
                    let extraParameters = ["KA":Constants.kaHeader,
                                           "iosBundleId":Bundle.main.bundleIdentifier,
                                           "lcba":serverCallbackArgs?.toJsonString()
                        ].filterNil()
                    
                    let linkParameters = ["appkey" : (targetAppKey != nil) ? targetAppKey! : try! KakaoSDK.shared.appKey(),
                                          "appver" : Constants.appVersion(),
                                          "linkver" : "4.0",
                                          "template_json" : validationResult.templateMsg.toJsonString(),
                                          "template_id" : validationResult.templateId,
                                          "template_args" : validationResult.templateArgs?.toJsonString(),
                                          "extras" : extraParameters?.toJsonString()
                        ].filterNil()
                    
                    if let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkLink, path:Paths.talkLink), parameters: linkParameters) {
                        SdkLog.d("--------------------------------url \(url)")
                        
                        if ShareApi.isExceededLimit(linkParameters: linkParameters, validationResult: validationResult, extras: extraParameters) {
                            observer.onError(SdkError(reason: .ExceedKakaoLinkSizeLimit))
                        } else {
                            observer.onNext(SharingResult(url: url, warningMsg: validationResult.warningMsg, argumentMsg: validationResult.argumentMsg))
                            observer.onCompleted()
                        }
                    }
                    else {
                        observer.onError(SdkError(reason:.BadParameter, message: "Invalid Url."))
                    }
                    return Disposables.create()
                }
            }
        }
    }
    
    // MARK: Using KakaoTalk
    
    func shareDefault(templateObjectJsonString:String?, serverCallbackArgs:[String:String]? = nil ) -> Single<SharingResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.shareDefalutValidate),
                                parameters: ["link_ver":"4.0",
                                             "template_object":templateObjectJsonString]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createSharingResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// ## SeeAlso
    /// - ``Template``
    /// - ``SharingResult``
    public func shareDefault(templatable: Templatable, serverCallbackArgs:[String:String]? = nil ) -> Single<SharingResult> {
        return self.shareDefault(templateObjectJsonString: templatable.toJsonObject()?.toJsonString(), serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// ## SeeAlso
    /// - ``SharingResult``
    public func shareDefault(templateObject:[String:Any], serverCallbackArgs:[String:String]? = nil ) -> Single<SharingResult> {
        return self.shareDefault(templateObjectJsonString: templateObject.toJsonString(), serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오톡으로 공유합니다.
    /// ## SeeAlso
    /// - ``SharingResult``
    public func shareScrap(requestUrl:String, templateId:Int64? = nil, templateArgs:[String:String]? = nil, serverCallbackArgs:[String:String]? = nil ) -> Single<SharingResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.shareScrapValidate),
                                parameters: ["link_ver":"4.0",
                                             "request_url":requestUrl,
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createSharingResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡으로 공유합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/latest/ko/message/ios#create-message 을 참고하시기 바랍니다.
    /// ## SeeAlso
    /// - ``SharingResult``
    public func shareCustom(templateId:Int64, templateArgs:[String:String]? = nil, serverCallbackArgs:[String:String]? = nil) -> Single<SharingResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.shareCustomValidate),
                                parameters: ["link_ver":"4.0",
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createSharingResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
 
    // MARK: Image Upload
    
    /// 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드 합니다.
    public func imageUpload(image: UIImage, secureResource: Bool = true) -> Single<ImageUploadResult> {
        return API.rx.upload(.post, Urls.compose(path:Paths.shareImageUpload),
                          images: [image],
                          parameters: ["secure_resource": secureResource],
                          headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                          sessionType: .Api)
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 카카오톡 공유 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 스크랩 합니다.
    public func imageScrap(imageUrl: URL, secureResource: Bool = true) -> Single<ImageUploadResult> {
        return API.rx.responseData(.post, Urls.compose(path:Paths.shareImageScrap),
                                parameters: ["image_url": imageUrl.absoluteString, "secure_resource": secureResource],
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDK.shared.appKey())"],
                                sessionType: .Api)
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
}
