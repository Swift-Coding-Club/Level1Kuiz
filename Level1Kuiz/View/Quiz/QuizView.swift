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
    @State var score: Int = 9
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
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden()
    }
    private func screenChangeScore(with score : Int)-> Color{
        if score <= 9{
            return Color.yellow
        }else if score <= 19{
            return Color.blue
        }else if score <= 29{
            return Color.green
        }else if score <= 39{
            return Color.orange
        }else if score <= 49{
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

}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
