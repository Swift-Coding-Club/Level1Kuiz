//
//  ShopView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var purchasedThemes: Set<String> = []

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.98)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // 코인 잔액
                        VStack(spacing: 10) {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.yellow)

                            Text("보유 코인")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)

                            Text("\(userDataManager.coins)")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange.opacity(0.5), lineWidth: 2)
                        )

                        // 테마 상점
                        VStack(alignment: .leading, spacing: 15) {
                            Text("테마 상점")
                                .font(.system(size: 22, weight: .bold))

                            VStack(spacing: 15) {
                                ForEach(AppTheme.allCases, id: \.self) { theme in
                                    ThemeCard(
                                        theme: theme,
                                        isOwned: theme == .light || purchasedThemes.contains(theme.rawValue),
                                        isCurrent: userDataManager.selectedTheme == theme
                                    ) {
                                        purchaseTheme(theme)
                                    }
                                }
                            }
                        }

                        // 코인 획득 방법
                        VStack(alignment: .leading, spacing: 15) {
                            Text("코인 획득 방법")
                                .font(.system(size: 22, weight: .bold))

                            VStack(spacing: 12) {
                                CoinMethodCard(
                                    icon: "gamecontroller.fill",
                                    title: "퀴즈 플레이",
                                    description: "점수에 따라 코인 획득",
                                    color: .blue
                                )

                                CoinMethodCard(
                                    icon: "trophy.fill",
                                    title: "업적 달성",
                                    description: "업적 달성 시 보상 코인",
                                    color: .orange
                                )

                                CoinMethodCard(
                                    icon: "flame.fill",
                                    title: "연속 출석",
                                    description: "매일 플레이하면 보너스",
                                    color: .red
                                )

                                CoinMethodCard(
                                    icon: "gauge.badge.plus",
                                    title: "높은 난이도",
                                    description: "고급/지옥 난이도는 배수 획득",
                                    color: .purple
                                )
                            }
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("상점")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
        .onAppear {
            loadPurchasedThemes()
        }
    }

    func loadPurchasedThemes() {
        if let data = UserDefaults.standard.array(forKey: "purchasedThemes") as? [String] {
            purchasedThemes = Set(data)
        }
    }

    func savePurchasedThemes() {
        UserDefaults.standard.set(Array(purchasedThemes), forKey: "purchasedThemes")
    }

    func purchaseTheme(_ theme: AppTheme) {
        if theme == .light {
            userDataManager.selectedTheme = theme
            userDataManager.saveData()
            alertMessage = "\(theme.rawValue) 테마가 적용되었습니다!"
            showingAlert = true
            return
        }

        if purchasedThemes.contains(theme.rawValue) {
            userDataManager.selectedTheme = theme
            userDataManager.saveData()
            alertMessage = "\(theme.rawValue) 테마가 적용되었습니다!"
            showingAlert = true
        } else {
            if userDataManager.spendCoins(theme.unlockCost) {
                purchasedThemes.insert(theme.rawValue)
                savePurchasedThemes()
                userDataManager.selectedTheme = theme
                userDataManager.saveData()
                alertMessage = "\(theme.rawValue) 테마를 구매하고 적용했습니다!"
                showingAlert = true
            } else {
                alertMessage = "코인이 부족합니다. \(theme.unlockCost - userDataManager.coins)코인이 더 필요합니다."
                showingAlert = true
            }
        }
    }
}

struct ThemeCard: View {
    let theme: AppTheme
    let isOwned: Bool
    let isCurrent: Bool
    let onPurchase: () -> Void

    var body: some View {
        HStack(spacing: 15) {
            // 테마 미리보기
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundColor)
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(theme.accentColor, lineWidth: 2)
                    )

                Text("Aa")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(theme.textColor)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(theme.rawValue)
                    .font(.system(size: 18, weight: .bold))

                if isCurrent {
                    Text("적용 중")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                } else if isOwned {
                    Text("보유 중")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                } else {
                    HStack(spacing: 4) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        Text("\(theme.unlockCost)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                }
            }

            Spacer()

            Button(action: onPurchase) {
                if isCurrent {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.green)
                } else if isOwned {
                    Text("적용")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(12)
                } else {
                    Text("구매")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CoinMethodCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
