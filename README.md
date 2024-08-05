# BOARDING - 비행기에 탑승하는 순간의 설레임 <img src="https://github.com/user-attachments/assets/01dce807-9d6b-4f9b-8adf-c17781570813" width="30" height="30">
> The Beginning of a New Journey
<br>
<br>

<div align="center">
  <img src="https://github.com/user-attachments/assets/01dce807-9d6b-4f9b-8adf-c17781570813" width="150" height="150">
  <br>
  <br>
  <img src="https://img.shields.io/badge/Swift-v5.9.2-red?logo=swift"/>
  <img src="https://img.shields.io/badge/Xcode-v15.1-blue?logo=Xcode"/>
  <img src="https://img.shields.io/badge/iOS-16.0+-black?logo=apple"/>  
  <br>
  <br>
  <a href="https://apps.apple.com/kr/app/boarding/id6473780848" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 180px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-US?size=250x83&amp" alt="Download on the App Store" style="border-radius: 13px; width: 180px; height: 83px;"></a>
</div>

<div align="center">
  <br>
  <img src="https://github.com/user-attachments/assets/556a7f72-782c-4d66-bc3c-d5691fea3904" width="19%"> <img src="https://github.com/user-attachments/assets/b10ab8fb-cf6c-45b2-8b73-bb8d89e7146c" width="19%"> <img src="https://github.com/user-attachments/assets/b4912550-3f3b-4dd4-9e1d-536045006fab" width="19%"> <img src="https://github.com/user-attachments/assets/ebfaad22-9d4d-4780-b85b-9d1ba50bcc04" width="19%"> <img src="https://github.com/user-attachments/assets/4a262d08-bef0-490d-bf49-736337bfe756" width="19%">
</div>
<br>

## 프로젝트 소개
`🛩️ 처음 여행을 준비하고 비행기 탑승을 기다리던 그 때의 설레임을 기억하시나요?`
> 사용자들이 기록한 게시물들을 스크랩해서 **나만의 플랜과 일정**을 만들 수 있는 커뮤니티 앱 서비스
<br>

## 프로젝트 주요 기능
- **카카오톡, 애플** 간편로그인 기능
- 홈 탭 내 유저 게시물 **좋아요, 댓글, 스크랩** 기능
- 동영상, 사진 형식의 게시물 업로드 가능, **Google Map 장소 데이터**와 연동
- 플립 인터렉션이 가능한 카드 형태로도 살펴볼 수 있는 게시글
- 스크랩한 게시글을 메모와 함께 **내 여행플랜**, **내 여행일정**에 추가 가능
- **내가 쓴 글, 마일리지, 여행 레벨, 차단 유저 관리** 기능
<br>

## 프로젝트 개발 환경
- 개발 인원
  - 디자이너 1명, iOS개발 1명
- 개발 기간
  - 2023.09 - 2024.01 (4개월)
- iOS 최소 버전
  - iOS 16.0+
<br>

## 프로젝트 기술 스택
- **활용기술 및 키워드**
  - **iOS** : swift 5.9.2, xcode 15.1, UIKit, Photos, Apple Authorization
  - **Network** : RxSwift, Firebase, Kakao API
  - **UI** : CodeBaseUI, Snapkit, Then

- **라이브러리**

라이브러리 | 사용 목적 | Version
:---------:|:----------:|:---------:
GoogleMap | 장소 세부 정보 | 8.3.1
FSCalendar | 플랜, 일정 날짜 선택  | 2.8.4
Kingfisher | 이미지 처리 | 7.0
FirebaseStorageUI | 저장소 이미지 처리 | -
<br>

## 프로젝트 아키텍처
<div align="center">
  <img src="https://github.com/user-attachments/assets/3e697e84-2395-4c91-a4b0-5a31cb54a5b5">
</div>
<br>

> RxSwift + MVVM Architecture
- SnapKit과 Then을 활용한 CodeBase UI로 생산성을 높이고, 반복되는 UI요소들에 대한 View의 재사용성을 높임
- Photos를 통해 가져온 유저 사진 데이터의 부족한 정보들을 Google Map 장소데이터와 연동하여 Storage에 저장
- Kakao Auth와 Apple Auth를 담당하는 모델들이 Firebase Auth 데이터와 연동되어 통합 Token으로 유저 로그인 상태 관리
<br>

## 트러블 슈팅
### 1. Firebase 기반 애플로그인의 '회원탈퇴'를 구현할 수 없는 문제
> Firebase내에 구현된 revokeToken 메소드는 Firebase내에서의 token만 다룰 뿐이지, 애플로그인 토큰 자체의 연결 해제까지는 할 수 없었다.
<div align="center">
  <img src="https://github.com/user-attachments/assets/91c8f3da-3662-426e-aeed-3010382240bd" width="75%"> <img src="https://github.com/user-attachments/assets/aaf1deb0-4a40-4c57-a47e-6a5369855a68" width="11.8%"> <img src="https://github.com/user-attachments/assets/2fc5269a-5b76-4824-a878-66ee90272871" width="11.8%"> 
</div>
<br>

- apple에게 Rest API Call을 보내서 revoke에 필요한 refresh Token을 가져온다. 이 과정에서 **JWT(JsonWebToken)생성**이 필요
- JWT를 클라이언트단에서 호출하는 것은 보안 문제가 발생할 수 있으므로, **Firebase Cloud Function**을 사용해서 서버리스 백엔드 기능을 사용
- SignIn을 하는 과정에서 받아온 Refresh Token을 **UserDefaults**에 저장한 다음, 회원 탈퇴 revoke Token시점에서 이를 사용하는 형태로 문제 해결
> Sign In
```swift
let credential = OAuthProvider.appleCredential(withIDToken: tokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)

if let code = appleIDCredential.authorizationCode, let codeString = String(data: code, encoding: .utf8) {
    //Use FireBase Cloud Function
    let url = URL(string: "https://us-central1-boarding-ef2f1.cloudfunctions.net/getRefreshToken?code=\(codeString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        if let data = data {
            //Get Refresh Token
            let refreshToken = String(data: data, encoding: .utf8) ?? ""
            //Save in UserDefaults
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        }
    }
    task.resume()
}

//Sign In with Credential
Auth.auth().signIn(with: credential) { ... }
```
> Withdraw
```swift
let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)

//Use Refresh Token Saved in UserDefaults
let token = UserDefaults.standard.string(forKey: "refreshToken")
if let token = token {
    //Revoke Token
    let url = URL(string: "https://us-central1-boarding-ef2f1.cloudfunctions.net/revokeToken?refresh_token=\(token)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "https://apple.com")!
    let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        guard data != nil else { return }
    }
    task.resume()
}

//Sign Out in FireBase
Auth.auth().signOut() { ... }
```
<br>

### 2. 세 개의 User Interaction이 겹치는 Sticky Header View
> Sticky Header View와 Page View Controller, 그리고 그 안에 Scroll View들이 병용되어야 하는 상황
<div align="center">
  <img src="https://github.com/user-attachments/assets/294c340e-e5ea-4637-84bb-3b295910d154" width="75%"> <img src="https://github.com/user-attachments/assets/bf090cc9-5918-4f50-8db5-c829fa26faff" width="11.8%"> <img src="https://github.com/user-attachments/assets/07fe762e-4e2e-470a-b0d6-6554e0096daa" width="11.8%"> 
</div>
<br>

- Pan Gesture의 state에 따른 translation과 velocity로 **Sticky Header View**를 우선적으로 구현 (이 때 y값만을 사용하여 Page View Controller의 interaction과 겹치지 않도록 설정) 
- Page List마다 RxSwift의 **BehaviorRelay**를 정의하여 Sticky Header View의 UI 상태를 Observe 할 수 있도록 설정
- BehaviorRelay를 View.isScrollEnabled의 값과 **bind**하여 Pan Gesture의 우선순위를 명시하여 인터렉션을 구현
> Sticky Header View
```swift
@objc func addModalMotion(_ recognizer: UIPanGestureRecognizer) {
    let minY = window.safeAreaInsets.top
    let maxY = self.maxY
    
    switch recognizer.state {
        
    case .began, .changed:
        //Set Translation
        let translation = recognizer.translation(in: modalView)
        //Set max, min Bound
        let y = min(maxY, max(minY, modalView.frame.minY + translation.y))
        //Change Top Constraints
        modalView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
    case .ended:
        //Direction of Pin Gesture
        let velocity = recognizer.velocity(in: modalView).y
        let shouldClose = velocity > 0
        //Auto Animation
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.modalView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(shouldClose ? maxY : minY)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        //Set BehaviorRelay to Each PageList
        modalPageViewController.pageList.forEach { vc in
            switch vc {
            case is NFTViewController:
                if let vc = vc as? NFTViewController {
                    vc.modalClosed.accept(shouldClose)
                }
            case is MILEViewController:
                if let vc = vc as? MILEViewController {
                    vc.modalClosed.accept(shouldClose)
                }
            default:
                if let vc = vc as? ExpertLevelViewController {
                    vc.modalClosed.accept(shouldClose)
                }
            }
        }
    default:
        break
    }
}
```
> Scroll View
```swift
//Set Default Value True
let modalClosed = BehaviorRelay<Bool>(value: true)

func setRx() {
    //Bind to ScrollView
    modalClosed
        .bind(with: self) { owner, isClosed in
            owner.ScrollView.isScrollEnabled = isClosed
        }
        .disposed(by: disposeBag)
}
```
<br>

### 3. FireStore Plan 문서 저장에서 순서 바꾸기, 삭제된 게시글 기능이 정상적으로 동작하지 않는 문제
> Plan 문서에 게시글 정보를 복사해서 모두 저장하다보니, 빠르게 수행되어야 하는 플랜 순서 바꾸기와 유저의 게시글 삭제 유무 탐색의 속도 문제가 있었다.
<div align="center">
  <img src="https://github.com/user-attachments/assets/fa1ee40a-a255-415c-90f2-bb95449cf9d3" width="75%"> <img src="https://github.com/user-attachments/assets/2256ca9e-4579-4121-b400-8fcec2f01c58" width="11.8%"> <img src="https://github.com/user-attachments/assets/77e2538c-854a-4ec5-8698-151643588a05" width="11.8%"> 
</div>
<br>

- 필요한 객체의 복사 기반 저장에서 Card 문서의 ID값을 저장하는 방식으로 변경
- ID값이 맞는 Card를 찾기 위해 모든 Card문서를 순회해야 하는 문제가 있으므로, 이는 **Firestore Custom 색인**을 생성하여 최적화
> Scroll View
```swift
//Set Default Value True
let modalClosed = BehaviorRelay<Bool>(value: true)

func setRx() {
    //Bind to ScrollView
    modalClosed
        .bind(with: self) { owner, isClosed in
            owner.ScrollView.isScrollEnabled = isClosed
        }
        .disposed(by: disposeBag)
}
```
