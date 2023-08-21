//
//  QuizService.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/08.
//

import Foundation

class QuizService {
    func fetchQuizzes() async throws -> [Quiz] {
        try await HTTPClient().request(
            type: [Quiz].self,
            path: "/quizzes",
            method: .get
        )
    }

    func fetchQuizExamples() async throws -> [[Quiz.Answer]] {
        try await HTTPClient().request(
            type: [[Quiz.Answer]].self,
            path: "/examples",
            method: .get
        )
    }
}
