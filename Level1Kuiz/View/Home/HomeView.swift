//
//  HomeView.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/01.
//

import SwiftUI

struct HomeView: View {

    static let TRANSITION_TIME_INTERVAL: TimeInterval = 5

    @StateObject private var quizExamplesModel = QuizExamplesModel()
    @ObservedObject var userDataManager = UserDataManager.shared
    @State private var isNavigationLinkActive = false
    @State private var showingStats = false
    @State private var showingAchievements = false
    @State private var showingWrongAnswers = false
    @State private var showingSettings = false
    @State private var timer = Timer.publish(every: TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
    @State private var answers: [Quiz.Answer] = [
        Quiz.Answer(text: "한글 날", isCorrect: false),
        Quiz.Answer(text: "한글날", isCorrect: true)
    ]

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        // 상단 메뉴 바
                        HStack {
                            // 사용자 정보
                            HStack(spacing: 8) {
                                Image(systemName: userDataManager.selectedAvatar)
                                    .font(.system(size: 24))
                                    .foregroundColor(.black)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(userDataManager.username)
                                        .font(.system(size: 14, weight: .bold))
                                    HStack(spacing: 8) {
                                        HStack(spacing: 2) {
                                            Image(systemName: "bitcoinsign.circle.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.orange)
                                            Text("\(userDataManager.coins)")
                                                .font(.system(size: 11, weight: .semibold))
                                        }
                                        HStack(spacing: 2) {
                                            Image(systemName: "flame.fill")
                                                .font(.system(size: 10))
                                                .foregroundColor(.red)
                                            Text("\(userDataManager.currentStreak)일")
                                                .font(.system(size: 11, weight: .semibold))
                                        }
                                    }
                                }
                            }

                            Spacer()

                            // 메뉴 버튼들
                            HStack(spacing: 12) {
                                Button(action: { showingStats = true }) {
                                    Image(systemName: "chart.bar.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }

                                Button(action: { showingAchievements = true }) {
                                    Image(systemName: "trophy.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }

                                Button(action: { showingWrongAnswers = true }) {
                                    Image(systemName: "book.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }

                                Button(action: { showingSettings = true }) {
                                    Image(systemName: "gearshape.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, geometry.safeAreaInsets.top + 8)
                        .padding(.bottom, 100)
                        .offset(y: -50)

                        // 예시 문제
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(answers, id: \.text) { answer in
                                Text("\(answer.text) (\(answer.isCorrect ? "O" : "X"))")
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                                    .transition(.offset(x: 0, y: 300))
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }

                GeometryReader { geometry in
                    VStack {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(alignment: .lastTextBaseline, spacing: 4) {
                                    Text("Kuiz")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                    Text("Korean Quiz")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                }

                                Text("Copyright(c) 2023 Swift Coding Club")
                                    .font(.caption2)
                            }
                            Text("심심할 때 띄어쓰기 한판 어떠세요?\n풀면 풀수록 재밌는 띄어쓰기 문제!\n지금 바로 시작해 보세요 😎")
                        }.padding(.top, 20)

                        Spacer()

                        NavigationLink(destination: QuizView(), isActive: $isNavigationLinkActive) {
                            Button {
                                isNavigationLinkActive = true
                            } label: {
                                Text("시작")
                                    .font(.system(size: 20))
                                    .fontWeight(.black)
                                    .frame(width: 160, height: 60)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(80)
                            }
                        }

                        Spacer()
                    }
                    .padding(EdgeInsets(top: 60, leading: 40, bottom: 10, trailing: 40))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .background(Color.yellow)
                    .cornerRadius(60, corners: [.topLeft, .topRight])
                }

            }
            .edgesIgnoringSafeArea(.all)
            .sheet(isPresented: $showingStats) {
                StatisticsView()
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementView()
            }
            .sheet(isPresented: $showingWrongAnswers) {
                WrongAnswerView()
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
        .onChange(of: isNavigationLinkActive, perform: { isActive in
            if isActive {
                timer.upstream.connect().cancel()
            } else {
                timer = Timer.publish(every: HomeView.TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
            }
        })
        .onReceive(timer) { _ in
            guard !quizExamplesModel.data.isEmpty else { return }

            withAnimation(.easeInOut(duration: 0.6)) {
                answers = quizExamplesModel.data.randomElement()!
            }
        }
        .preferredColorScheme(.light)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
