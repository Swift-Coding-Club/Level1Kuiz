//
//  SettingsView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingProfile = false
    @State private var showingShop = false

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

                        Text("설정")
                            .font(.system(size: 28, weight: .bold))

                        Spacer()

                        Spacer()
                            .frame(width: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    // 프로필 카드
                    Button(action: { showingProfile = true }) {
                        HStack(spacing: 15) {
                            Image(systemName: userDataManager.selectedAvatar)
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                                .frame(width: 70, height: 70)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 6) {
                                Text(userDataManager.username)
                                    .font(.system(size: 22, weight: .bold))

                                if !userDataManager.selectedTitle.isEmpty {
                                    Text(userDataManager.selectedTitle)
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }

                                HStack(spacing: 15) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "bitcoinsign.circle.fill")
                                            .foregroundColor(.yellow)
                                        Text("\(userDataManager.coins)")
                                            .font(.system(size: 14, weight: .bold))
                                    }

                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(.orange)
                                        Text("\(userDataManager.currentStreak)일")
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                }
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal, 20)

                    // 게임 설정
                    VStack(alignment: .leading, spacing: 15) {
                        Text("게임 설정")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 20)

                        VStack(spacing: 1) {
                            // 난이도 선택
                            HStack {
                                Image(systemName: "gauge")
                                    .foregroundColor(.blue)
                                    .frame(width: 30)
                                Text("난이도")
                                    .font(.system(size: 16))
                                Spacer()
                                Menu {
                                    ForEach(DifficultyLevel.allCases, id: \.self) { difficulty in
                                        Button(action: {
                                            userDataManager.selectedDifficulty = difficulty
                                            userDataManager.saveData()
                                        }) {
                                            HStack {
                                                Text(difficulty.rawValue)
                                                if userDataManager.selectedDifficulty == difficulty {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(userDataManager.selectedDifficulty.rawValue)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(15)
                            .background(Color.white)

                            Divider()
                                .padding(.leading, 60)

                            // 카테고리 선택
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.green)
                                    .frame(width: 30)
                                Text("카테고리")
                                    .font(.system(size: 16))
                                Spacer()
                                Menu {
                                    ForEach(QuizCategory.allCases, id: \.self) { category in
                                        Button(action: {
                                            userDataManager.selectedCategory = category
                                            userDataManager.saveData()
                                        }) {
                                            HStack {
                                                Text(category.rawValue)
                                                if userDataManager.selectedCategory == category {
                                                    Image(systemName: "checkmark")
                                                }
                                            }
                                        }
                                    }
                                } label: {
                                    HStack(spacing: 4) {
                                        Text(userDataManager.selectedCategory.rawValue)
                                            .foregroundColor(.gray)
                                        Image(systemName: "chevron.down")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(15)
                            .background(Color.white)

                            Divider()
                                .padding(.leading, 60)

                            // 사운드 설정
                            HStack {
                                Image(systemName: "speaker.wave.2")
                                    .foregroundColor(.purple)
                                    .frame(width: 30)
                                Text("사운드")
                                    .font(.system(size: 16))
                                Spacer()
                                Toggle("", isOn: $userDataManager.soundEnabled)
                                    .labelsHidden()
                                    .onChange(of: userDataManager.soundEnabled) { _ in
                                        userDataManager.saveData()
                                    }
                            }
                            .padding(15)
                            .background(Color.white)
                        }
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }

                    // 앱 정보
                    VStack(alignment: .leading, spacing: 15) {
                        Text("앱 정보")
                            .font(.system(size: 18, weight: .bold))
                            .padding(.horizontal, 20)

                        VStack(spacing: 1) {
                            Button(action: { showingShop = true }) {
                                HStack {
                                    Image(systemName: "bag")
                                        .foregroundColor(.orange)
                                        .frame(width: 30)
                                    Text("상점")
                                        .font(.system(size: 16))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(15)
                                .background(Color.white)
                            }

                            Divider()
                                .padding(.leading, 60)

                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.gray)
                                    .frame(width: 30)
                                Text("버전")
                                    .font(.system(size: 16))
                                Spacer()
                                Text("1.0.0")
                                    .foregroundColor(.gray)
                            }
                            .padding(15)
                            .background(Color.white)
                        }
                        .cornerRadius(15)
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 30)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
        .sheet(isPresented: $showingShop) {
            ShopView()
        }
    }
}
