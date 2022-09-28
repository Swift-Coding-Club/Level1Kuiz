//
//  SampleData.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/28.
//

import Foundation

// 샘플 데이터
struct SampleData: Identifiable {
    var id: Int

    let quizString: String?
    let correctAnswer: String
    let wrongAnswer: String
}
