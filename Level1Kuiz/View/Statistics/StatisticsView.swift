//
//  StatisticsView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.98)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // 헤더
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.blue)
                        }

                        Spacer()

                        Text("통계")
                            .font(.system(size: 28, weight: .bold))

                        Spacer()

                        Spacer()
                            .frame(width: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // 주요 통계
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                        StatCard(
                            title: "총 플레이",
                            value: "\(userDataManager.statistics.totalGamesPlayed)",
                            icon: "gamecontroller.fill",
                            color: .blue
                        )

                        StatCard(
                            title: "최고 점수",
                            value: "\(userDataManager.statistics.highestScore)",
                            icon: "star.fill",
                            color: .yellow
                        )

                        StatCard(
                            title: "평균 점수",
                            value: String(format: "%.1f", userDataManager.statistics.averageScore),
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green
                        )

                        StatCard(
                            title: "정답률",
                            value: String(format: "%.1f%%", userDataManager.statistics.accuracyRate),
                            icon: "target",
                            color: .orange
                        )

                        StatCard(
                            title: "연속 출석",
                            value: "\(userDataManager.currentStreak)일",
                            icon: "flame.fill",
                            color: .red
                        )

                        StatCard(
                            title: "최고 콤보",
                            value: "\(userDataManager.statistics.highestCombo)",
                            icon: "bolt.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal, 20)

                    // 등급별 도달 횟수
                    VStack(alignment: .leading, spacing: 15) {
                        Text("등급별 도달 횟수")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal, 20)

                        VStack(spacing: 10) {
                            RankBar(rank: "맞춤법 더듬이", count: userDataManager.statistics.newbieCount, color: .yellow)
                            RankBar(rank: "일반인", count: userDataManager.statistics.normalCount, color: .blue)
                            RankBar(rank: "맞춤법 변태", count: userDataManager.statistics.proCount, color: .green)
                            RankBar(rank: "맞춤법 달인", count: userDataManager.statistics.masterCount, color: .orange)
                            RankBar(rank: "국립국어원 직원", count: userDataManager.statistics.expertCount, color: .cyan)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    }

                    // 최근 기록
                    if !userDataManager.statistics.recentScores.isEmpty {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("최근 기록")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 20)

                            VStack(spacing: 10) {
                                ForEach(userDataManager.statistics.recentScores) { record in
                                    RecentGameCard(record: record)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)

            Text(value)
                .font(.system(size: 28, weight: .bold))

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct RankBar: View {
    let rank: String
    let count: Int
    let color: Color

    var maxCount: Int {
        max(count, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(rank)
                    .font(.system(size: 14, weight: .medium))
                Spacer()
                Text("\(count)회")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(count) / CGFloat(max(maxCount, 10)), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}

struct RecentGameCard: View {
    let record: GameRecord

    var body: some View {
        HStack(spacing: 15) {
            VStack(spacing: 4) {
                Text(record.date, style: .date)
                    .font(.system(size: 12, weight: .medium))
                Text(record.date, style: .time)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .frame(width: 60)

            Divider()

            VStack(alignment: .leading, spacing: 4) {
                Text("\(record.score)점")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.blue)

                HStack(spacing: 10) {
                    Label("\(record.correctAnswers)/\(record.questionsAnswered)", systemImage: "checkmark.circle")
                        .font(.system(size: 12))
                    Label("\(record.combo)", systemImage: "bolt.fill")
                        .font(.system(size: 12))
                    Text(record.difficulty.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                .foregroundColor(.gray)
            }

            Spacer()

            Text(Rank(score: record.score).rawValue)
                .font(.system(size: 12, weight: .bold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(getRankColor(record.score).opacity(0.2))
                .foregroundColor(getRankColor(record.score))
                .cornerRadius(10)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    func getRankColor(_ score: Int) -> Color {
        switch Rank(score: score) {
        case .newbie: return .yellow
        case .normal: return .blue
        case .pro: return .green
        case .master: return .orange
        case .expert: return .cyan
        }
    }
}
