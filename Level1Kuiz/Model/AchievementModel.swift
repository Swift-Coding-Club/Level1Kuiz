//
//  AchievementModel.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import Foundation

// 업적 타입
enum AchievementType: String, Codable, CaseIterable {
    case firstQuiz = "first_quiz"
    case score100 = "score_100"
    case streak7 = "streak_7"
    case streak30 = "streak_30"
    case streak100 = "streak_100"
    case perfect30 = "perfect_30"
    case expert10 = "expert_10"
    case combo10 = "combo_10"
    case fastAnswer = "fast_answer"
    case totalGames100 = "total_games_100"

    var title: String {
        switch self {
        case .firstQuiz: return "첫걸음"
        case .score100: return "백점왕"
        case .streak7: return "일주일 마스터"
        case .streak30: return "한 달 챔피언"
        case .streak100: return "백일의 기적"
        case .perfect30: return "완벽주의자"
        case .expert10: return "국어의 신"
        case .combo10: return "콤보 마스터"
        case .fastAnswer: return "번개손"
        case .totalGames100: return "백전노장"
        }
    }

    var description: String {
        switch self {
        case .firstQuiz: return "첫 퀴즈 완료"
        case .score100: return "100점 달성"
        case .streak7: return "7일 연속 플레이"
        case .streak30: return "30일 연속 플레이"
        case .streak100: return "100일 연속 플레이"
        case .perfect30: return "한 번도 안 틀리고 30문제 풀기"
        case .expert10: return "Expert 등급 10회 달성"
        case .combo10: return "10연속 콤보 달성"
        case .fastAnswer: return "3초 이내에 10문제 연속 정답"
        case .totalGames100: return "총 100회 플레이"
        }
    }

    var emoji: String {
        switch self {
        case .firstQuiz: return "🎯"
        case .score100: return "💯"
        case .streak7: return "📅"
        case .streak30: return "🔥"
        case .streak100: return "👑"
        case .perfect30: return "✨"
        case .expert10: return "🏆"
        case .combo10: return "⚡"
        case .fastAnswer: return "⚡"
        case .totalGames100: return "🎖️"
        }
    }

    var coinReward: Int {
        switch self {
        case .firstQuiz: return 10
        case .score100: return 100
        case .streak7: return 50
        case .streak30: return 200
        case .streak100: return 500
        case .perfect30: return 150
        case .expert10: return 300
        case .combo10: return 50
        case .fastAnswer: return 80
        case .totalGames100: return 250
        }
    }
}

// 업적 데이터
struct Achievement: Codable, Identifiable {
    var id: String { type.rawValue }
    let type: AchievementType
    var isUnlocked: Bool
    var unlockedDate: Date?
    var progress: Int // 진행도 (예: Expert 10회 중 5회)
    var maxProgress: Int

    var progressPercent: Double {
        guard maxProgress > 0 else { return 0 }
        return Double(progress) / Double(maxProgress) * 100
    }
}
