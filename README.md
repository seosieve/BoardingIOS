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
