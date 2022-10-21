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

    private let sampleQuizzes: [Quiz] = [
        Quiz(id: "0", answers: [Quiz.Answer(text: "이곳은 국립국어원입니다.", isCorrect: true), Quiz.Answer(text: "이곳은 국립국어원 입니다.", isCorrect: false)], description: "국립국어원입니다 가 맞습니다!"),
        Quiz(id: "1", answers: [Quiz.Answer(text: "집에서만 이라도 좀 쉬세요.", isCorrect: false), Quiz.Answer(text: "집에서만이라도 좀 쉬세요.", isCorrect: true)], description: "집에서만이라도 가 맞습니다!"),
        Quiz(id: "2", answers: [Quiz.Answer(text: "친구 같이 지내는 사이입니다.", isCorrect: false), Quiz.Answer(text: "친구같이 지내는 사이입니다.", isCorrect: true)], description: "친구같이 가 맞습니다!"),
        Quiz(id: "3", answers: [Quiz.Answer(text: "나 조차도.", isCorrect: false), Quiz.Answer(text: "나조차도", isCorrect: true)], description: "나조차도 가 맞습니다!"),
        Quiz(id: "4", answers: [Quiz.Answer(text: "불러 낼", isCorrect: false), Quiz.Answer(text: "불러낼", isCorrect: true)], description: "불러낼 이 맞습니다!"),
        Quiz(id: "5", answers: [Quiz.Answer(text: "확인 할", isCorrect: false), Quiz.Answer(text: "확인할", isCorrect: true)], description: "확인할 이 맞습니다!"),
        Quiz(id: "6", answers: [Quiz.Answer(text: "안돼", isCorrect: false), Quiz.Answer(text: "안 돼", isCorrect: true)], description: "안 돼 가 맞습니다!"),
        Quiz(id: "7", answers: [Quiz.Answer(text: "첫번째, 두번째", isCorrect: false), Quiz.Answer(text: "첫 번째, 두 번째", isCorrect: true)], description: "첫 번째, 두 번째 가 맞습니다!"),
        Quiz(id: "8", answers: [Quiz.Answer(text: "몇년전부터", isCorrect: false), Quiz.Answer(text: "몇 년 전부터", isCorrect: true)], description: "몇 년 전부터 가 맞습니다!"),
        Quiz(id: "9", answers: [Quiz.Answer(text: "쓰기전에", isCorrect: false), Quiz.Answer(text: "쓰기 전에", isCorrect: true)], description: "쓰기 전에 가 맞습니다!")
    ]

    func getQuizzes() -> [Quiz] {
        return sampleQuizzes
    }

}
