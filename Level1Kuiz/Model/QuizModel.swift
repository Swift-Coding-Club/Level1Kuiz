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

@MainActor
class QuizExamplesModel: ObservableObject {
    @Published var data: [[Quiz.Answer]] = []

    init() {
        Task {
            data = try await QuizService().fetchQuizExamples()
        }
    }
}
