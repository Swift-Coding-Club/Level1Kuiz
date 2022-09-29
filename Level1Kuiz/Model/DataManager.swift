//
//  DataManager.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/28.
//

import Foundation

class DataManager {

    // 싱글톤 패턴 사용
    static let share = DataManager()
    private init() {}

    private let sampleDatas: [SampleData] = [
        SampleData(id: 0, quizString: "_ 같은 박수가 나왔다.", correctAnswer: "우레", wrongAnswer: "우뢰"),
        SampleData(id: 1, quizString: "그의 무례한 행동은 저절로 _ 을 찌푸리게 했다.", correctAnswer: "눈살", wrongAnswer: "눈쌀"),
        SampleData(id: 2, quizString: nil, correctAnswer: "화룡점정", wrongAnswer: "화룡정점"),
        SampleData(id: 3, quizString: nil, correctAnswer: "맛 좋은", wrongAnswer: "맛좋은"),
        SampleData(id: 4, quizString: "_ 발언하세요.", correctAnswer: "상대측", wrongAnswer: "상대 측"),
        SampleData(id: 5, quizString: nil, correctAnswer: "예부터", wrongAnswer: "옛부터"),
        SampleData(id: 6, quizString: "그녀는 눈에 초점이 없고 _ 한 상태였다.", correctAnswer: "흐리멍덩", wrongAnswer: "흐리멍텅"),
        SampleData(id: 7, quizString: nil, correctAnswer: "갈가리 찢다", wrongAnswer: "갈갈이 찢다"),
        SampleData(id: 8, quizString: nil, correctAnswer: "답변드렸다", wrongAnswer: "답변 드렸다"),
        SampleData(id: 9, quizString: "약이 _ 를 보이다.", correctAnswer: "즉효", wrongAnswer: "직효")
    ]

    func getData() -> [SampleData] {
        return sampleDatas
    }

}
