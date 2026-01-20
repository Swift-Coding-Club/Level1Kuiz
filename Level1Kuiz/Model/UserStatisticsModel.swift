//
//  UserStatisticsModel.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import Foundation

// 사용자 통계
struct UserStatistics: Codable {
    var totalGamesPlayed: Int = 0
    var totalQuestionsAnswered: Int = 0
    var totalCorrectAnswers: Int = 0
    var highestScore: Int = 0
    var totalScore: Int = 0

    // 등급별 도달 횟수
    var newbieCount: Int = 0
    var normalCount: Int = 0
    var proCount: Int = 0
    var masterCount: Int = 0
    var expertCount: Int = 0

    // 콤보 기록
    var highestCombo: Int = 0

    // 완벽한 게임 (한 번도 안 틀림)
    var perfectGames: Int = 0

    // 게임 기록 (최근 10개)
    var recentScores: [GameRecord] = []

    var averageScore: Double {
        guard totalGamesPlayed > 0 else { return 0 }
        return Double(totalScore) / Double(totalGamesPlayed)
    }

    var accuracyRate: Double {
        guard totalQuestionsAnswered > 0 else { return 0 }
        return Double(totalCorrectAnswers) / Double(totalQuestionsAnswered) * 100
    }

    mutating func recordGame(_ record: GameRecord) {
        totalGamesPlayed += 1
        totalQuestionsAnswered += record.questionsAnswered
        totalCorrectAnswers += record.correctAnswers
        totalScore += record.score

        if record.score > highestScore {
            highestScore = record.score
        }

        if record.combo > highestCombo {
            highestCombo = record.combo
        }

        if record.livesLost == 0 && record.questionsAnswered >= 30 {
            perfectGames += 1
        }

        // 등급별 카운트
        switch Rank(score: record.score) {
        case .newbie: newbieCount += 1
        case .normal: normalCount += 1
        case .pro: proCount += 1
        case .master: masterCount += 1
        case .expert: expertCount += 1
        }

        // 최근 기록 추가
        recentScores.insert(record, at: 0)
        if recentScores.count > 10 {
            recentScores.removeLast()
        }
    }
}

// 게임 기록
struct GameRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let score: Int
    let questionsAnswered: Int
    let correctAnswers: Int
    let combo: Int
    let livesLost: Int
    let hintsUsed: Int
    let difficulty: DifficultyLevel
    let category: QuizCategory?

    init(score: Int, questionsAnswered: Int, correctAnswers: Int, combo: Int, livesLost: Int, hintsUsed: Int, difficulty: DifficultyLevel = .medium, category: QuizCategory? = nil) {
        self.id = UUID()
        self.date = Date()
        self.score = score
        self.questionsAnswered = questionsAnswered
        self.correctAnswers = correctAnswers
        self.combo = combo
        self.livesLost = livesLost
        self.hintsUsed = hintsUsed
        self.difficulty = difficulty
        self.category = category
    }
}

// 난이도
enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "초급"
    case medium = "중급"
    case hard = "고급"
    case hell = "지옥"

    var timeLimit: Double {
        switch self {
        case .easy: return 8.0
        case .medium: return 5.0
        case .hard: return 3.0
        case .hell: return 2.0
        }
    }

    var initialLives: Int {
        switch self {
        case .easy: return 5
        case .medium: return 3
        case .hard: return 3
        case .hell: return 1
        }
    }

    var initialHints: Int {
        switch self {
        case .easy: return 5
        case .medium: return 3
        case .hard: return 1
        case .hell: return 0
        }
    }

    var scoreMultiplier: Double {
        switch self {
        case .easy: return 0.5
        case .medium: return 1.0
        case .hard: return 1.5
        case .hell: return 2.0
        }
    }

    var description: String {
        switch self {
        case .easy: return "쉬운 문제, 힌트 많음"
        case .medium: return "일반 난이도"
        case .hard: return "어려운 문제, 시간 제한"
        case .hell: return "매우 어려운 문제, 라이프 1개"
        }
    }
}

// 퀴즈 카테고리
enum QuizCategory: String, Codable, CaseIterable {
    case spacing = "띄어쓰기"
    case spelling = "맞춤법"
    case foreignWord = "외래어 표기법"
    case idiom = "속담/관용구"
    case hanja = "한자어"
    case all = "전체"

    var icon: String {
        switch self {
        case .spacing: return "space"
        case .spelling: return "pencil"
        case .foreignWord: return "globe"
        case .idiom: return "book"
        case .hanja: return "character"
        case .all: return "star"
        }
    }
}

// 오답 노트
struct WrongAnswer: Codable, Identifiable {
    let id: UUID
    let quiz: Quiz
    let userAnswer: String
    let correctAnswer: String
    let date: Date
    var reviewCount: Int

    init(quiz: Quiz, userAnswer: String, correctAnswer: String) {
        self.id = UUID()
        self.quiz = quiz
        self.userAnswer = userAnswer
        self.correctAnswer = correctAnswer
        self.date = Date()
        self.reviewCount = 0
    }
}
