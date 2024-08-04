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
  <img src="https://github.com/seosieve/TopazIOS/assets/76729543/2741e194-9176-498b-b3df-aaebfa8ab5fb" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/47a43577-9195-419f-8955-19cbbc9e3976" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/32af170b-bd75-4403-9088-a6a8738dc86e" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/bb7a0500-e432-448e-a0e9-15453a0a8f5b" width="19%"> <img src="https://github.com/seosieve/TopazIOS/assets/76729543/f7ab2a41-f783-4643-be66-726fe1a31b1e" width="19%">
</div>
<br>

## 프로젝트 소개
`🛩️ 처음 여행을 준비하고 비행기 탑승을 기다리던 그 때의 설레임을 기억하시나요?`
> 사용자들이 기록한 게시물들을 스크랩해서 **나만의 플랜과 일정**을 만들 수 있는 커뮤니티 앱 서비스
<br>

## 프로젝트 주요 기능
- **카카오톡, 애플** 간편로그인 기능
- 홈 탭 내 유저 게시물 **좋아요, 댓글, 스크랩** 기능
- 대륙에 따른 여행지 추천, 검색 기능
- 커뮤니티 게시글 **작성 / 수정 / 삭제 / 검색**
- 게시글과 함께 작성할 수 있는 **커스텀 배경음악** 기능
- **내가 쓴 글, 프로필, 차단유저, 여행등급, 수집품** 관리 기능
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
  - **iOS** : swift 5.8, xcode 15.0.1, UIKit, SceneKit
  - **Network** : URLSession, Firebase
  - **UI** : StoryBoard

- **라이브러리**

라이브러리 | 사용 목적 | Version
:---------:|:----------:|:---------:
SwiftySound | 배경음악 처리 | -
Kingfisher | 이미지 처리 | 7.0
lottie-ios | 스플래시, 로딩 인디케이터 | -
<br>

## 프로젝트 아키텍처
<div align="center">
  <img src="https://github.com/user-attachments/assets/a9c0ae36-70e4-4fbf-a753-4b2bce2170dc">
</div>
<br>

> StoryBoard + MVVM Architecture
- 3D Base UI등 Custom UI가 많아 커뮤니케이션과 전체적인 UI Flow관찰을 위해 StoryBoard 활용
- Manager객체에서 API Fetching 및 FireBase CRUD 구현 로직을 담당, ViewModel에서 호출
- Auth Token 저장 및 UserID 등 불필요한 API Call을 줄이기 위해 UserDefaults 저장소 병용
<br>
