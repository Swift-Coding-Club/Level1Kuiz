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

// class QuizModel: ObservableObject {
//    @Published var data: [Quiz] = []
//
//    init() {
//        QuizService().getQuizzes { result in
//            switch result {
//            case .success(let data):
//                self.data = data
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
// }

class QuizExamplesModel: ObservableObject {
    @Published var data: [[Quiz.Answer]] = []

    init() {
        QuizService().getQuizExamples { result in
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error):
                print(error)
            }
        }
    }
}
