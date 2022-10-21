//
//  QuizService.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/08.
//

import Foundation

class QuizService {
    func getQuizzes(completeHandler: @escaping (Result<[Quiz], Error>) -> Void) {
        HTTPClient().request(path: "/quizzes", method: .get) { (result: Result<[Quiz], Error>) in
            completeHandler(result)
        }
    }

    func getQuizExamples(completeHandler: @escaping (Result<[[Quiz.Answer]], Error>) -> Void) {
        HTTPClient().request(path: "/examples", method: .get) { (result: Result<[[Quiz.Answer]], Error>) in
            completeHandler(result)
        }
    }
}
