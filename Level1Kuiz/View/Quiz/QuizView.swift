//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI
import SwiftUIMargin

struct QuizView: View {

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffSet = CGSize.zero

    @State var quizzes: [Quiz] = []
    @State var score: Int = 0
    @State var answer: String = ""
    @State var description: String = ""
    @State var randomBool: Bool = Bool.random()
    @State var isQuizEnded: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                NavigationLink(
                    destination: ResultView(
                        score: score,
                        answer: answer,
                        description: description
                    ),
                    isActive: $isQuizEnded
                ) {}
                    .hidden()

                Color.yellow
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("당신은 \(getRankByScore(with: score).rawValue)!")
                        .font(Font.system(size: 20, weight: .semibold))
                    Spacer()
                    VStack {
                        Text("\(score)")
                            .font(Font.system(size: 80))
                            .fontWeight(.bold)

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
                        .onAppear {
                            QuizService().getQuizzes { result in
                                switch result {
                                case .success(let data):
                                    quizzes = data.shuffled()
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                        .margin(top: 40)
                    }
                    Spacer()
                }
                
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
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
