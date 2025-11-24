//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI
import SwiftUIMargin
import ConfettiSwiftUI

struct QuizView: View {

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffSet = CGSize.zero
    @ObservedObject var userDataManager = UserDataManager.shared

    @State var quizzes: [Quiz] = []
    @State var score: Int = 0
    @State var answer: String = ""
    @State var description: String = ""
    @State var randomBool: Bool = Bool.random()
    @State var isQuizEnded: Bool = false
    @State var scoreCounter: Int = 0
    @State var isEvent: Bool = false
    @State var scoreBar: Double = 0.0

    // 타임 어택 모드
    @State var timeRemaining: Double = 5.0
    @State var timer: Timer?
    @State var timeBonus: Double = 0.0

    // 콤보 시스템
    @State var comboCount: Int = 0
    @State var showComboMessage: Bool = false
    @State var comboMessage: String = ""
    @State var comboEmoji: String = ""
    @State var maxComboReached: Int = 0

    // 라이프 시스템
    @State var lives: Int = 3
    @State var initialLives: Int = 3
    @State var livesLost: Int = 0

    // 힌트 시스템
    @State var hintsRemaining: Int = 3
    @State var showHint: Bool = false
    @State var hintUsedForCurrentQuestion: Bool = false
    @State var totalHintsUsed: Int = 0

    // 통계
    @State var questionsAnswered: Int = 0
    @State var correctAnswers: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NavigationLink(
                    destination: ResultView(
                        score: score,
                        answer: answer,
                        description: description,
                        scoreColor: screenChangeScore(with: score)
                    ),
                    isActive: $isQuizEnded
                ) {}
                    .hidden()
                screenChangeScore(with: score)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.default, value: score)

                VStack {
                    // 상단 정보 영역
                    HStack {
                        // 라이프 표시
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Image(systemName: index < lives ? "heart.fill" : "heart")
                                    .foregroundColor(index < lives ? .red : .white.opacity(0.3))
                                    .font(.system(size: 24))
                            }
                        }
                        .padding(.leading, 20)

                        Spacer()

                        // 콤보 카운터
                        if comboCount > 0 {
                            HStack(spacing: 4) {
                                Text("\(comboCount)")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                Text("COMBO")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.8))
                            .cornerRadius(20)
                        }

                        Spacer()

                        // 힌트 버튼
                        Button(action: {
                            if hintsRemaining > 0 && !hintUsedForCurrentQuestion && !quizzes.isEmpty {
                                hintsRemaining -= 1
                                hintUsedForCurrentQuestion = true
                                totalHintsUsed += 1
                                showHint = true
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "lightbulb.fill")
                                    .font(.system(size: 22, weight: .bold))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("힌트")
                                        .font(.system(size: 13, weight: .bold))
                                    Text("\(hintsRemaining)개 남음")
                                        .font(.system(size: 10, weight: .medium))
                                }
                            }
                            .foregroundColor(hintsRemaining > 0 && !hintUsedForCurrentQuestion ? .yellow : .white.opacity(0.3))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                (hintsRemaining > 0 && !hintUsedForCurrentQuestion ? Color.black.opacity(0.5) : Color.white.opacity(0.15))
                            )
                            .cornerRadius(16)
                            .shadow(color: hintsRemaining > 0 && !hintUsedForCurrentQuestion ? Color.yellow.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                        }
                        .disabled(hintsRemaining == 0 || hintUsedForCurrentQuestion)
                        .padding(.trailing, 20)
                    }
                    .padding(.top, 50)

                    // 타이머 게이지
                    VStack(spacing: 8) {
                        HStack {
                            Text("남은 시간")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                            Text(String(format: "%.1f초", timeRemaining))
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 8)
                                    .cornerRadius(4)

                                Rectangle()
                                    .fill(timeRemaining > 2 ? Color.green : (timeRemaining > 1 ? Color.orange : Color.red))
                                    .frame(width: geo.size.width * CGFloat(timeRemaining / 5.0), height: 8)
                                    .cornerRadius(4)
                                    .animation(.linear(duration: 0.1), value: timeRemaining)
                            }
                        }
                        .frame(height: 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    ProgressView("다음 등급까지 \(10 - Int(scoreBar))문제 남았어요.", value: scoreBar, total: 10)
                        .font(Font.system(size: 20, weight: .medium))
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 50, trailing: 20))

                    VStack {
                        Text("\(score)")
                            .font(Font.system(size: 80))
                            .fontWeight(.bold)
                            .fullScreenCover(isPresented: $isEvent, content: {
                                ReachEffectView(nowScore: $score, isEvent: $isEvent)
                            })

                        // 콤보 메시지
                        if showComboMessage {
                            HStack(spacing: 8) {
                                Text(comboEmoji)
                                    .font(.system(size: 30))
                                Text(comboMessage)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(20)
                            .transition(.scale.combined(with: .opacity))
                        }

                        // 힌트 표시
                        if showHint && !quizzes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "lightbulb.fill")
                                        .foregroundColor(.yellow)
                                    Text("힌트")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                Text(quizzes[score].description)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(15)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                        }

                        VStack(alignment: .center, spacing: 12) {
                            if quizzes.isEmpty {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(2)
                            } else {
                                generateAnswerText(index: Int(randomBool), geometry: geometry)
                                generateAnswerText(index: Int(!randomBool), geometry: geometry)
                            }
                        }
                    }
                    .onAppear {
                        // 난이도에 따른 설정 적용
                        let difficulty = userDataManager.selectedDifficulty
                        lives = difficulty.initialLives
                        initialLives = difficulty.initialLives
                        hintsRemaining = difficulty.initialHints

                        Task {
                            let quizzes = try await QuizService().fetchQuizzes()
                            self.quizzes = quizzes.shuffled()
                            startTimer()
                        }
                    }
                    .margin(top: 40)
                    Spacer()
                }
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
    }
    private func screenChangeScore(with score: Int) -> Color {
        if score <= 9 {
            return Color.yellow
        } else if score <= 19 {
            return Color.blue
        } else if score <= 29 {
            return Color.green
        } else if score <= 39 {
            return Color.orange
        } else if score <= 49 {
            return Color.cyan
        }
            return Color.yellow
    }

    func generateAnswerText(index: Int, geometry: GeometryProxy) -> some View {
        Text(quizzes[score].answers[index].text)
            .fontWeight(.black)
            .frame(minWidth: geometry.size.width * 0.6)
            .font(.system(size: 20))
            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
            .background(.white)
            .cornerRadius(80, antialiased: true)
            .onTapGesture {
                stopTimer()
                questionsAnswered += 1

                if quizzes[score].answers[index].isCorrect {
                    // 정답 처리
                    correctAnswers += 1
                    var earnedScore = 1

                    // 타임 보너스 계산
                    timeBonus = timeRemaining * 0.5
                    earnedScore += Int(timeBonus)

                    // 콤보 증가
                    comboCount += 1
                    if comboCount > maxComboReached {
                        maxComboReached = comboCount
                    }

                    // 콤보 보너스 계산
                    let comboBonus = getComboBonus()
                    earnedScore += comboBonus

                    // 힌트 사용 시 점수 반감
                    if hintUsedForCurrentQuestion {
                        earnedScore = earnedScore / 2
                    }

                    score += earnedScore
                    scoreBar += 1

                    // 콤보 메시지 표시
                    if comboBonus > 0 {
                        showComboEffect()
                    }

                    // 등급 달성 이벤트
                    if score % 10 == 0 {
                        isEvent = true
                        scoreBar = 0
                    }

                    // 특정 점수마다 하트 회복
                    if score % 20 == 0 && lives < initialLives {
                        lives += 1
                    }

                    // 다음 문제로
                    moveToNextQuestion()

                } else {
                    // 오답 처리
                    lives -= 1
                    livesLost += 1
                    comboCount = 0

                    // 오답 노트에 추가
                    let userAnswer = quizzes[score].answers[index].text
                    let correctAnswer = quizzes[score].answers[index == 0 ? 1 : 0].text
                    userDataManager.addWrongAnswer(
                        quiz: quizzes[score],
                        userAnswer: userAnswer,
                        correctAnswer: correctAnswer
                    )

                    if lives <= 0 {
                        // 게임 오버
                        answer = correctAnswer
                        description = quizzes[score].description
                        recordGameResult()
                        isQuizEnded = true
                    } else {
                        // 라이프가 남아있으면 계속 진행
                        moveToNextQuestion()
                    }
                }

                if score == quizzes.count {
                    recordGameResult()
                    isQuizEnded = true
                }
            }
    }

    // MARK: - Game Result Recording
    private func recordGameResult() {
        userDataManager.recordGameResult(
            score: score,
            questionsAnswered: questionsAnswered,
            correctAnswers: correctAnswers,
            combo: maxComboReached,
            livesLost: livesLost,
            hintsUsed: totalHintsUsed
        )
    }

    // MARK: - Timer Functions
    private func startTimer() {
        let difficulty = userDataManager.selectedDifficulty
        timeRemaining = difficulty.timeLimit
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 0.1
            } else {
                // 시간 초과
                stopTimer()
                questionsAnswered += 1
                lives -= 1
                livesLost += 1
                comboCount = 0

                // 오답 노트에 추가
                let correctAnswer = quizzes[score].answers[0].isCorrect ? quizzes[score].answers[0].text : quizzes[score].answers[1].text
                let userAnswer = "" // 시간 초과이므로 빈 문자열
                userDataManager.addWrongAnswer(
                    quiz: quizzes[score],
                    userAnswer: userAnswer,
                    correctAnswer: correctAnswer
                )

                if lives <= 0 {
                    answer = correctAnswer
                    description = quizzes[score].description
                    recordGameResult()
                    isQuizEnded = true
                } else {
                    moveToNextQuestion()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        let difficulty = userDataManager.selectedDifficulty
        timeRemaining = difficulty.timeLimit
        startTimer()
    }

    // MARK: - Combo Functions
    private func getComboBonus() -> Int {
        switch comboCount {
        case 3:
            return 1
        case 5:
            return 3
        case 10:
            return 5
        default:
            return 0
        }
    }

    private func showComboEffect() {
        withAnimation {
            switch comboCount {
            case 3:
                comboMessage = "불타오르네!"
                comboEmoji = "🔥"
            case 5:
                comboMessage = "신의 손!"
                comboEmoji = "⚡"
            case 10:
                comboMessage = "완벽함!"
                comboEmoji = "💎"
            default:
                return
            }

            showComboMessage = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showComboMessage = false
            }
        }
    }

    // MARK: - Game Flow Functions
    private func moveToNextQuestion() {
        randomBool = Bool.random()
        hintUsedForCurrentQuestion = false
        showHint = false
        resetTimer()
    }

    private func getRankByScore(with score: Int) -> Rank {
        if score >= 40 {
            return Rank.expert
        } else if score >= 30 {
            return Rank.master
        } else if score >= 20 {
            return Rank.pro
        } else if score >= 10 {
            return Rank.normal
        } else {
            return Rank.newbie
        }
    }

}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
