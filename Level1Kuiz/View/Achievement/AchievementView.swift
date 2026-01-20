//
//  AchievementView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI

struct AchievementView: View {
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

                        Text("업적")
                            .font(.system(size: 28, weight: .bold))

                        Spacer()

                        // 코인 표시
                        HStack(spacing: 4) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .foregroundColor(.yellow)
                            Text("\(userDataManager.coins)")
                                .font(.system(size: 16, weight: .bold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // 진행도 요약
                    let unlockedCount = userDataManager.achievements.filter { $0.isUnlocked }.count
                    let totalCount = userDataManager.achievements.count

                    VStack(spacing: 8) {
                        Text("달성한 업적")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)

                        Text("\(unlockedCount) / \(totalCount)")
                            .font(.system(size: 36, weight: .bold))

                        ProgressView(value: Double(unlockedCount), total: Double(totalCount))
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(x: 1, y: 2)
                            .padding(.horizontal, 40)
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)

                    // 업적 리스트
                    VStack(spacing: 12) {
                        ForEach(userDataManager.achievements) { achievement in
                            AchievementCard(achievement: achievement)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        HStack(spacing: 15) {
            // 아이콘
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.yellow.opacity(0.3) : Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)

                Text(achievement.type.emoji)
                    .font(.system(size: 30))
                    .grayscale(achievement.isUnlocked ? 0 : 1)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.type.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(achievement.isUnlocked ? .black : .gray)

                Text(achievement.type.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)

                if achievement.maxProgress > 1 {
                    HStack(spacing: 8) {
                        ProgressView(value: Double(achievement.progress), total: Double(achievement.maxProgress))
                            .progressViewStyle(LinearProgressViewStyle(tint: achievement.isUnlocked ? .blue : .gray))
                            .frame(height: 4)

                        Text("\(achievement.progress)/\(achievement.maxProgress)")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }

                if achievement.isUnlocked, let date = achievement.unlockedDate {
                    HStack(spacing: 4) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text("+\(achievement.type.coinReward)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.orange)
                        Text("•")
                            .foregroundColor(.gray)
                        Text(date, style: .date)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()

            if achievement.isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.green)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
