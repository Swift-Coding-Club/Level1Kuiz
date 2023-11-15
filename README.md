# Everyone Can Swift! 🥳

![스위프트 코딩 클럽](https://user-images.githubusercontent.com/16731356/205471879-92636e25-7e68-463f-9835-8fd8b15c0f18.png)

## 참여 대상

행사 참석자 누구나 참여할 수 있어요.

## 이슈 목록

1. 결과화면 공유하기 버튼을 네비게이션바로 이동 -> 난이도 하
2. 제공된 문제를 다 풀면 더 남은 문제가 없다는 최종달성 뷰 만들어주기 -> 난이도 하
3. 퀴즈 기록 화면 적용 -> 난이도 중

해당 이슈 외에도 추가하고 싶은 기술이 있으시면 추가하시면 됩니다! 하고 싶은게 있다면 언제든지 이슈 추가 후 개발 및 배포까지 다 가능합니다. 

이 앱에 흥미가 있으다면 언제든지 연락 주세요! 😎

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

# Kuiz - 우리말 띄어쓰기!

<div align="center">
  <img src="https://user-images.githubusercontent.com/16731356/205376037-3f4b996e-19c9-4bb8-9ab3-544a2727cfb7.gif" alt="데모" />
</div>

## 개요

Kuiz(퀴즈)는 Korean Quiz의 줄임말이에요. 사람들이 글을 쓸 때 많이 틀리는 띄어쓰기를 게임으로 만들어 봤어요.

심심할 때 띄어쓰기 한판 어떠세요? 최고 등급에 도전해보세요! 😎

## 프로젝트 실행

1. 이 저장소를 클론해 주세요.
2. 프로젝트를 Xcode로 열어 주세요. (최소 Xcode 15.0 버전 이상이어야 해요.)
3. ⌘+R 키를 누르고 시뮬레이터를 실행해 주세요.

## 사용 기술 

### GeometryReader

SwiftUI에서 제공하는 여러 컨테이너 뷰 중 하나로 자식 뷰에게 부모 뷰와 기기에 대한 전반적인 정보를 전달해요. 반응형으로 뷰의 너비와 높이를 계산하려고 사용했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Home/HomeView.swift#L25))

### Network

띄어쓰기 문제들을 프로젝트 내부나 외부의 데이터베이스에 저장하는 대신 [Mock API](https://mockapi.io/)에 저장하고 `Alamofire` 패키지를 사용해서 가져왔어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/Network/HTTPClient.swift))

### cornerRadius Extension

특정 모서리에만 값을 주고 싶은데 SwiftUI에서 제공하는 `cornerRadius` 함수는 무조건 모든 모서리에 값을 주더라고요. 그래서 함수를 확장해서 만들었어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/Extension/ViewExtension.swift))

### Timer Animation

특정 시간 간격으로 애니메이션을 실행하고 싶어서 사용했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Home/HomeView.swift#L83))

### ConfettiSwiftUI

승급 조건을 충족했을때 축하합니다! 메세지와 함께 Confetti를 터트려 유저를 축하하기 위해 `ConfettiSwiftUI` 라이브러리를 활용하여 개발했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Quiz/ReachEffectView.swift))

### UIViewControllerRepresentable

유저끼리 게임 결과를 공유했으면 좋겠다고 생각했어요. 
하지만 현재 SwiftUI에는 공유하기가 따로 없어서 UIKit의 ViewController 타입을 SwiftUI의 View 타입으로 변경하여 사용할 수 있는 `UIViewControllerRepresentable`를 활용하여 개발했어요. ([코드](https://github.com/Swift-Coding-Club/Level1Kuiz/blob/main/Level1Kuiz/View/Result/ShareView.swift))

## 팀원 소개

지속가능한 앱을 만들고자 노력하고 있는 팀원의 명단이에요. 😎

`멤버 이미지 커밍쑨...`

🐥 샐리: https://github.com/aroundus

🦫 스뇽: https://github.com/ericKwon95

🐹 햄식: https://github.com/hamsik22

🕊️ 리이오: https://github.com/M1zz

🦫 갱이: https://github.com/gaeng2y

🐻‍❄️ 수하: https://github.com/sueunal

🦥 린다: https://github.com/syss220211

🐢 점영: https://github.com/Dtzer0
