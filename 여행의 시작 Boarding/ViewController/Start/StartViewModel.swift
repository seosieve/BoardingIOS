//
//  StartViewModel.swift
//  여행의 시작 Boarding
//
//  Created by 서충원 on 2023/09/15.
//

import Foundation
import RxSwift
import RxCocoa
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AuthenticationServices

class StartViewModel: NSObject {
    var currentNonce: String?
    let userNotExist = PublishSubject<Void>()
    
    let errorCatch = PublishRelay<Bool>()
    let startResult = PublishRelay<Bool>()
    
    let disposeBag = DisposeBag()
}

//MARK: - Apple SignUp
extension StartViewModel {
    func appleLogIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
}

extension StartViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else { return }
            guard let appleIdToken = appleIDCredential.identityToken else { return }
            guard let tokenString = String(data: appleIdToken, encoding: .utf8) else { return }
            let credential = OAuthProvider.appleCredential(withIDToken: tokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            if let code = appleIDCredential.authorizationCode, let codeString = String(data: code, encoding: .utf8) {
                let url = URL(string: "https://us-central1-boarding-ef2f1.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
                let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                    if let data = data {
                        let refreshToken = String(data: data, encoding: .utf8) ?? ""
                        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                    }
                }
                task.resume()
            }
            
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                if let error = error {
                    print(error)
                    self?.errorCatch.accept(true)
                } else {
                    let fullName = appleIDCredential.fullName!
                    let displayName = [fullName.givenName, fullName.familyName].compactMap{$0}.joined()
                    if displayName == "" {
                        //로그아웃 후 애플로그인 할 때
                        self?.startResult.accept(true)
                    } else {
                        //처음 애플로그인 할 때
                        self?.userNotExist.onNext(())
                        //firestore, Storage 저장
                        DispatchQueue.global().async {
                            self?.saveUserImage(url: User.defaultUrl) { [weak self] url in
                                self?.saveProfile(url: url!, name: displayName)
                            }
                        }
                        //Auth 수정
                        self?.makeProfile(nickname: displayName, thumbnail: User.defaultUrl)
                    }
                    print("유저 로그인 성공")
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //X버튼 누를때도 실행되기 때문에 에러처리 안했음
        self.startResult.accept(false)
        print("애플 로그인 에러: \(error.localizedDescription)")
    }
}

//MARK: - Kakao SignUp
extension StartViewModel {
    func kakaoLogIn() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(false)
                    print("카카오톡(APP) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { [weak self] _ in
                    self?.kakaoUserInfo()
                }, onError: { [weak self] error in
                    self?.errorCatch.accept(false)
                    print("카카오계정(WEB) 로그인 에러: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    func kakaoUserInfo() {
        UserApi.shared.rx.me()
            .subscribe(onSuccess:{ [weak self] user in
                if let email = user.kakaoAccount?.email,
                   let password = user.id,
                   let nickname = user.kakaoAccount?.profile?.nickname,
                   let thumbnail = user.kakaoAccount?.profile?.profileImageUrl {
                    print(thumbnail)
                    self?.signInUser(email: email, password: String(password), nickname: nickname, thumbnail: thumbnail)
                } else {
                    self?.errorCatch.accept(true)
                }
            }, onFailure: { [weak self] error in
                self?.errorCatch.accept(true)
                print("카카오 유저 정보 불러오기 에러: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func signInUser(email: String, password: String, nickname: String, thumbnail: URL) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                let code = (error as NSError).code
                print(code, error)
                switch code {
                case 17011:
                    //유저가 존재하지 않을때
                    self?.userNotExist.onNext(())
                    //유저 생성
                    self?.createUser(email: email, password: password, nickname: nickname, thumbnail: thumbnail)
                default:
                    self?.errorCatch.accept(true)
                }
            } else if let authResult = authResult {
                self?.startResult.accept(true)
                print("유저 로그인 성공: \(authResult)")
            }
        }
    }
    
    func createUser(email: String, password: String, nickname: String, thumbnail: URL) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (authResult, error) in
            if let error = error {
                self?.errorCatch.accept(true)
                print("파이어베이스 유저 생성 에러: \(error)")
            } else if let authResult = authResult {
                //credential용 UserDefaults 저장
                UserDefaults.standard.set(email, forKey: "kakaoEmail")
                UserDefaults.standard.set(password, forKey: "kakaoPassword")
                //firestore, Storage 저장
                DispatchQueue.global().async {
                    self?.saveUserImage(url: thumbnail) { [weak self] url in
                        self?.saveProfile(url: url!, name: nickname)
                    }
                }
                //Auth 수정
                self?.makeProfile(nickname: nickname, thumbnail: thumbnail)
                print("유저 생성 성공: \(authResult)")
            }
        }
    }
    
    func makeProfile(nickname: String, thumbnail: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nickname
        changeRequest?.photoURL = thumbnail
        changeRequest?.commitChanges { [weak self] error in
            if let error = error {
                self?.errorCatch.accept(true)
                print("파이어베이스 프로필 생성 에러: \(error)")
            } else {
                print("파이어베이스 프로필 생성 성공")
            }
        }
    }
    
    func saveUserImage(url: URL, completion: @escaping (URL?) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        guard let imageData = try? Data(contentsOf: url) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageRef = ref.child("UserImage/\(user.uid)")
        imageRef.putData(imageData, metadata: metaData) { metaData, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                imageRef.downloadURL { url, _ in
                    completion(url)
                }
            }
        }
    }
    
    func saveProfile(url: URL, name: String) {
        guard let user = Auth.auth().currentUser else { return }
        let User = User(userUid: user.uid, url: url.absoluteString, name: name, introduce: "", blockedUser: [], bookMark: [])
        db.collection("User").document(user.uid).setData(User.dicType) { [weak self] error in
            if let error = error {
                print("유저 저장 에러: \(error)")
                self?.errorCatch.accept(true)
            } else {
                print("유저 저장 성공: \(user.uid)")
                self?.startResult.accept(true)
            }
        }
    }
}
