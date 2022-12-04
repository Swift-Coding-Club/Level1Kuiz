# 송년회 이벤트 🥳

결과 등급이 높은 순서대로 5분에게 소소한 선물을 드려요! 🎁

* MOFT 아이패드 거치대 ([링크](https://www.moft.us/products/snap-ipad-case-stand-new?variant=39697408131159))
* 스타벅스 기프티콘

![스위프트 코딩 클럽](https://user-images.githubusercontent.com/16731356/205471879-92636e25-7e68-463f-9835-8fd8b15c0f18.png)

## 참여 대상

송년회 참석자 누구나 참여할 수 있어요.

## 참여 방법

1. 이 저장소를 클론해 주세요.
2. 프로젝트를 Xcode로 열어 주세요.
3. 게임을 진행해 주세요.
4. 결과 화면을 캡처해 주세요.
5. 디스코드 💬 **얘기해요** 채널에 올려 주세요.

---

<br />
<br />

<div align="center">
  <img src="https://user-images.githubusercontent.com/16731356/205466883-e9611648-436c-41ee-9238-cdd1c780f322.png" alt="로고" height="100" />
</div>
<br />
<p align="center">
  <a href="https://github.com/Swift-Coding-Club/Level1Kuiz/graphs/contributors" alt="Contributors">
    <img src="https://img.shields.io/github/contributors/Swift-Coding-Club/Level1Kuiz" />
  </a>
  <a href="https://github.com/Swift-Coding-Club/Level1Kuiz/pulse" alt="Activity">
    <img src="https://img.shields.io/github/commit-activity/m/Swift-Coding-Club/Level1Kuiz" />
  </a>
</p>
<br />

# Kuiz - 우리말 띄어쓰기

<div align="center">
  <img src="https://user-images.githubusercontent.com/16731356/205376037-3f4b996e-19c9-4bb8-9ab3-544a2727cfb7.gif" alt="데모" />
</div>

## 개요

Kuiz(퀴즈)는 Korean Quiz의 줄임말이에요. 사람들이 글을 쓸 때 많이 틀리는 띄어쓰기를 게임으로 만들어 봤어요. 게임을 하다 보면 여러분은 맞춤법 더듬이에서 빠져나올 수 없을 거예요. 심심할 때 띄어쓰기 한판 어떠세요? 지금 바로 시작해 보세요! 😎

## 실행

1. 이 저장소를 클론해 주세요.
2. 프로젝트를 Xcode로 열어 주세요. (최소 iOS 15.0 버전 이상이어야 해요.)
3. ⌘+R 키를 누르고 시뮬레이터를 실행해 주세요.

## 기술

### GeometryReader

SwiftUI에서 제공하는 여러 컨테이너 뷰 중 하나로 자식 뷰에게 부모 뷰와 기기에 대한 전반적인 정보를 전달해요. 반응형으로 뷰의 너비와 높이를 계산하려고 사용했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Home/HomeView.swift#L25))

### Network

띄어쓰기 문제들을 프로젝트 내부나 외부의 데이터베이스에 저장하는 대신 [Mock API](https://mockapi.io/)에 저장하고 Alamofire 패키지를 사용해서 가져왔어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/Network/HTTPClient.swift))

### cornerRadius Extension

특정 모서리에만 값을 주고 싶은데 SwiftUI에서 제공하는 `cornerRadius` 함수는 무조건 모든 모서리에 값을 주더라고요. 그래서 함수를 확장해서 만들었어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/Extension/ViewExtension.swift))

### Timer Animation

특정 시간 간격으로 애니메이션을 실행하고 싶어서 사용했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Home/HomeView.swift#L83))

## 팀 소개

<div align="center">
  <img src="https://user-images.githubusercontent.com/16731356/205472700-6c871e1b-17aa-428e-81f2-b97c78c552f5.png" alt="팀" height="160" />

  https://github.com/Swift-Coding-Club/Level1/wiki
</div>
<br />

개발 자체가 처음이고, 스위프트가 첫 언어인 사람들이 모인다는 취지로 탄생했어요. 샐리는 개발이 처음은 아니지만 Swift 언어는 처음 접하기도 하고 동료들이 방향성을 찾을 수 없을 때 조금이나마 도움을 줄 수 있는 역할을 하고 싶어서 참여하게 됐어요.
