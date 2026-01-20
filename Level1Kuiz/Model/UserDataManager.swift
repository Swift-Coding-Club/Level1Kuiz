//
//  UserDataManager.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import Foundation
import SwiftUI

class UserDataManager: ObservableObject {
    static let shared = UserDataManager()

    // Published properties
    @Published var coins: Int = 0
    @Published var currentStreak: Int = 0
    @Published var longestStreak: Int = 0
    @Published var lastPlayDate: Date?
    @Published var achievements: [Achievement] = []
    @Published var statistics: UserStatistics = UserStatistics()
    @Published var wrongAnswers: [WrongAnswer] = []
    @Published var selectedDifficulty: DifficultyLevel = .medium
    @Published var selectedCategory: QuizCategory = .all
    @Published var selectedTheme: AppTheme = .light
    @Published var soundEnabled: Bool = true
    @Published var username: String = "퀴즈마스터"
    @Published var selectedAvatar: String = "person.circle.fill"
    @Published var selectedTitle: String = ""

    private let defaults = UserDefaults.standard

    // Keys
    private enum Keys {
        static let coins = "coins"
        static let currentStreak = "currentStreak"
        static let longestStreak = "longestStreak"
        static let lastPlayDate = "lastPlayDate"
        static let achievements = "achievements"
        static let statistics = "statistics"
        static let wrongAnswers = "wrongAnswers"
        static let selectedDifficulty = "selectedDifficulty"
        static let selectedCategory = "selectedCategory"
        static let selectedTheme = "selectedTheme"
        static let soundEnabled = "soundEnabled"
        static let username = "username"
        static let selectedAvatar = "selectedAvatar"
        static let selectedTitle = "selectedTitle"
    }

    private init() {
        loadData()
        initializeAchievements()
    }

    // MARK: - Data Persistence

    private func loadData() {
        coins = defaults.integer(forKey: Keys.coins)
        currentStreak = defaults.integer(forKey: Keys.currentStreak)
        longestStreak = defaults.integer(forKey: Keys.longestStreak)

        if let dateData = defaults.object(forKey: Keys.lastPlayDate) as? Date {
            lastPlayDate = dateData
        }

        if let data = defaults.data(forKey: Keys.achievements),
           let decoded = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = decoded
        }

        if let data = defaults.data(forKey: Keys.statistics),
           let decoded = try? JSONDecoder().decode(UserStatistics.self, from: data) {
            statistics = decoded
        }

        if let data = defaults.data(forKey: Keys.wrongAnswers),
           let decoded = try? JSONDecoder().decode([WrongAnswer].self, from: data) {
            wrongAnswers = decoded
        }

        if let difficultyRaw = defaults.string(forKey: Keys.selectedDifficulty),
           let difficulty = DifficultyLevel(rawValue: difficultyRaw) {
            selectedDifficulty = difficulty
        }

        if let categoryRaw = defaults.string(forKey: Keys.selectedCategory),
           let category = QuizCategory(rawValue: categoryRaw) {
            selectedCategory = category
        }

        if let themeRaw = defaults.string(forKey: Keys.selectedTheme),
           let theme = AppTheme(rawValue: themeRaw) {
            selectedTheme = theme
        }

        soundEnabled = defaults.bool(forKey: Keys.soundEnabled)

        if let name = defaults.string(forKey: Keys.username), !name.isEmpty {
            username = name
        }

        if let avatar = defaults.string(forKey: Keys.selectedAvatar), !avatar.isEmpty {
            selectedAvatar = avatar
        }

        if let title = defaults.string(forKey: Keys.selectedTitle) {
            selectedTitle = title
        }
    }

    func saveData() {
        defaults.set(coins, forKey: Keys.coins)
        defaults.set(currentStreak, forKey: Keys.currentStreak)
        defaults.set(longestStreak, forKey: Keys.longestStreak)
        defaults.set(lastPlayDate, forKey: Keys.lastPlayDate)
        defaults.set(soundEnabled, forKey: Keys.soundEnabled)
        defaults.set(username, forKey: Keys.username)
        defaults.set(selectedAvatar, forKey: Keys.selectedAvatar)
        defaults.set(selectedTitle, forKey: Keys.selectedTitle)
        defaults.set(selectedDifficulty.rawValue, forKey: Keys.selectedDifficulty)
        defaults.set(selectedCategory.rawValue, forKey: Keys.selectedCategory)
        defaults.set(selectedTheme.rawValue, forKey: Keys.selectedTheme)

        if let encoded = try? JSONEncoder().encode(achievements) {
            defaults.set(encoded, forKey: Keys.achievements)
        }

        if let encoded = try? JSONEncoder().encode(statistics) {
            defaults.set(encoded, forKey: Keys.statistics)
        }

        if let encoded = try? JSONEncoder().encode(wrongAnswers) {
            defaults.set(encoded, forKey: Keys.wrongAnswers)
        }
    }

    // MARK: - Achievements

    private func initializeAchievements() {
        if achievements.isEmpty {
            achievements = AchievementType.allCases.map { type in
                let maxProgress: Int
                switch type {
                case .expert10: maxProgress = 10
                case .perfect30: maxProgress = 30
                case .totalGames100: maxProgress = 100
                case .combo10: maxProgress = 10
                case .fastAnswer: maxProgress = 10
                default: maxProgress = 1
                }

                return Achievement(
                    type: type,
                    isUnlocked: false,
                    unlockedDate: nil,
                    progress: 0,
                    maxProgress: maxProgress
                )
            }
            saveData()
        }
    }

    func unlockAchievement(_ type: AchievementType) {
        if let index = achievements.firstIndex(where: { $0.type == type }) {
            if !achievements[index].isUnlocked {
                achievements[index].isUnlocked = true
                achievements[index].unlockedDate = Date()
                coins += type.coinReward
                saveData()
            }
        }
    }

    func updateAchievementProgress(_ type: AchievementType, progress: Int) {
        if let index = achievements.firstIndex(where: { $0.type == type }) {
            achievements[index].progress = progress
            if progress >= achievements[index].maxProgress && !achievements[index].isUnlocked {
                unlockAchievement(type)
            }
            saveData()
        }
    }

    // MARK: - Streak Management

    func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        if let lastDate = lastPlayDate {
            let lastPlayDay = calendar.startOfDay(for: lastDate)
            let daysDifference = calendar.dateComponents([.day], from: lastPlayDay, to: today).day ?? 0

            if daysDifference == 1 {
                // 연속 출석
                currentStreak += 1
                if currentStreak > longestStreak {
                    longestStreak = currentStreak
                }
            } else if daysDifference > 1 {
                // 연속 끊김
                currentStreak = 1
            }
            // daysDifference == 0 이면 오늘 이미 플레이함
        } else {
            // 첫 플레이
            currentStreak = 1
            longestStreak = 1
        }

        lastPlayDate = Date()

        // 스트릭 업적 체크
        if currentStreak >= 7 {
            unlockAchievement(.streak7)
        }
        if currentStreak >= 30 {
            unlockAchievement(.streak30)
        }
        if currentStreak >= 100 {
            unlockAchievement(.streak100)
        }

        saveData()
    }

    // MARK: - Game Recording

    func recordGameResult(score: Int, questionsAnswered: Int, correctAnswers: Int, combo: Int, livesLost: Int, hintsUsed: Int) {
        let record = GameRecord(
            score: score,
            questionsAnswered: questionsAnswered,
            correctAnswers: correctAnswers,
            combo: combo,
            livesLost: livesLost,
            hintsUsed: hintsUsed,
            difficulty: selectedDifficulty,
            category: selectedCategory
        )

        statistics.recordGame(record)

        // 코인 획득 (난이도 배수 적용)
        let earnedCoins = Int(Double(score) * selectedDifficulty.scoreMultiplier)
        coins += earnedCoins

        // 업적 체크
        if statistics.totalGamesPlayed == 1 {
            unlockAchievement(.firstQuiz)
        }

        if score >= 100 {
            unlockAchievement(.score100)
        }

        if combo >= 10 {
            unlockAchievement(.combo10)
        }

        if livesLost == 0 && questionsAnswered >= 30 {
            updateAchievementProgress(.perfect30, progress: statistics.perfectGames)
        }

        updateAchievementProgress(.expert10, progress: statistics.expertCount)
        updateAchievementProgress(.totalGames100, progress: statistics.totalGamesPlayed)

        updateStreak()
        saveData()
    }

    // MARK: - Wrong Answers

    func addWrongAnswer(quiz: Quiz, userAnswer: String, correctAnswer: String) {
        let wrongAnswer = WrongAnswer(quiz: quiz, userAnswer: userAnswer, correctAnswer: correctAnswer)
        wrongAnswers.insert(wrongAnswer, at: 0)

        // 최대 50개까지만 저장
        if wrongAnswers.count > 50 {
            wrongAnswers.removeLast()
        }

        saveData()
    }

    func removeWrongAnswer(_ id: UUID) {
        wrongAnswers.removeAll { $0.id == id }
        saveData()
    }

    func incrementReviewCount(_ id: UUID) {
        if let index = wrongAnswers.firstIndex(where: { $0.id == id }) {
            wrongAnswers[index].reviewCount += 1
            saveData()
        }
    }

    // MARK: - Coins

    func spendCoins(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            saveData()
            return true
        }
        return false
    }

    func addCoins(_ amount: Int) {
        coins += amount
        saveData()
    }
}

// 테마
enum AppTheme: String, Codable, CaseIterable {
    case light = "라이트"
    case dark = "다크"
    case pastel = "파스텔"
    case retro = "레트로"

    var backgroundColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color.black
        case .pastel: return Color(red: 0.95, green: 0.95, blue: 1.0)
        case .retro: return Color(red: 1.0, green: 0.95, blue: 0.85)
        }
    }

    var textColor: Color {
        switch self {
        case .light: return Color.black
        case .dark: return Color.white
        case .pastel: return Color(red: 0.3, green: 0.3, blue: 0.5)
        case .retro: return Color(red: 0.4, green: 0.2, blue: 0.1)
        }
    }

    var accentColor: Color {
        switch self {
        case .light: return Color.blue
        case .dark: return Color.cyan
        case .pastel: return Color.purple.opacity(0.6)
        case .retro: return Color.orange
        }
    }

    var unlockCost: Int {
        switch self {
        case .light: return 0
        case .dark: return 100
        case .pastel: return 200
        case .retro: return 300
        }
    }
}
