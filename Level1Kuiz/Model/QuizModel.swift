//
//  Quiz.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/08.
//

import Foundation

struct Quiz: Identifiable, Decodable {
    var id: String
    var answers: [Answer]
    var description: String

    struct Answer: Decodable {
        var text: String
        var isCorrect: Bool
    }
}

class QuizExamplesModel: ObservableObject {
    @Published var examples: [[Quiz.Answer]] = []

    init() {
        QuizService().getQuizExamples { result in
            switch result {
            case .success(let data):
                self.examples = data
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct SampleQuiz: Identifiable {
    var id = UUID()

    let quizString: String?
    let correctAnswer: String
    let wrongAnswer: String
}
