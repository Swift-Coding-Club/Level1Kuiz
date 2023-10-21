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

    @State var quizzes: [Quiz] = []
    @State var score: Int = 0
    @State var answer: String = ""
    @State var description: String = ""
    @State var randomBool: Bool = Bool.random()
    @State var isQuizEnded: Bool = false
    @State var scoreCounter: Int = 0
    @State var isEvent: Bool = false
    @State var scoreBar: Double = 0.0

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
                    ProgressView("다음 등급까지 \(10 - Int(scoreBar))문제 남았어요.", value: scoreBar, total: 10)
                        .font(Font.system(size: 20, weight: .medium))
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .padding(EdgeInsets(top: 50, leading: 20, bottom: 150, trailing: 20))

                    VStack {
                        Text("\(score)")
                            .font(Font.system(size: 80))
                            .fontWeight(.bold)
                            .fullScreenCover(isPresented: $isEvent, content: {
                                ReachEffectView(nowScore: $score, isEvent: $isEvent)
                            })
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
                        Task {
                            let quizzes = try await QuizService().fetchQuizzes()
                            self.quizzes = quizzes.shuffled()
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
                if quizzes[score].answers[index].isCorrect {
                    score += 1
                    scoreBar += 1
                    if score % 10 == 0 {
                        isEvent = true
                        scoreBar = 0
                    }
                } else {
                    answer = quizzes[score].answers[index == 0 ? 1 : 0].text
                    description = quizzes[score].description
                    isQuizEnded = true
                }

                if score == quizzes.count {
                    isQuizEnded = true
                }

                randomBool = Bool.random()
            }
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
