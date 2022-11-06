//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI

struct QuizView: View {

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffSet = CGSize.zero

    @State var quizzes: [Quiz] = []
    @State var randomQuizIndexes: [Int] = [0, 1]
    @State var currentCount: Int = 0
    @State var didGetQuizWrong: Bool = false
    @State var isQuizEnded: Bool = false

    @Binding var isNavigationLinkActive: Bool
    @State var isShowingResultView = false

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                NavigationLink(destination: ResultView(isNavigationLinkActive: $isNavigationLinkActive, correctCount: currentCount), isActive: $isShowingResultView) {}
                    .hidden()

                Color.yellow
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                        .frame(height: geometry.size.height * 0.05)
                    Text("\(currentCount)")
                        .font(Font.system(size: 75).bold())
                        .fontWeight(.bold)
                    Spacer()
                        .frame(height: geometry.size.height * 0.08)
                    ZStack {
                        Color.white
                            .cornerRadius(60, corners: [.topLeft, .topRight])
                            .edgesIgnoringSafeArea(.bottom)
                        VStack(alignment: .center, spacing: 20) {
                            if !quizzes.isEmpty {

                                Text(quizzes[currentCount].answers[randomQuizIndexes[0]].text)
                                    .frame(minWidth: geometry.size.width * 0.7)
                                    .font(Font.title2.bold())
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    .background(.white)
                                    .cornerRadius(40, antialiased: true)
                                    .shadow(radius: 1)
                                    .onTapGesture {
                                        if quizzes[currentCount].answers[randomQuizIndexes[0]].isCorrect {
                                            currentCount += 1
                                        } else {
                                            // 문제 틀리면 결과 화면으로..
                                            didGetQuizWrong = true
                                            if !isQuizEnded && didGetQuizWrong {
                                                isShowingResultView = true
                                            }
                                            if isQuizEnded && !didGetQuizWrong {
                                                isShowingResultView = true
                                            }
                                        }
                                        if currentCount == quizzes.count {
                                            isQuizEnded = true
                                        }
                                        randomQuizIndexes.shuffle()
                                    }
                                Text(quizzes[currentCount].answers[randomQuizIndexes[1]].text)
                                    .frame(minWidth: geometry.size.width * 0.7)
                                    .font(Font.title2.bold())
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    .background(.white)
                                    .cornerRadius(40, antialiased: true)
                                    .shadow(radius: 1)
                                    .onTapGesture {
                                        if quizzes[currentCount].answers[randomQuizIndexes[1]].isCorrect {
                                            currentCount += 1
                                        } else {
                                            // 문제 틀리면 결과 화면으로..
                                            didGetQuizWrong = true
                                            if !isQuizEnded && didGetQuizWrong {
                                                isShowingResultView = true
                                            }
                                            if isQuizEnded && !didGetQuizWrong {
                                                isShowingResultView = true
                                            }
                                        }
                                        if currentCount == quizzes.count {
                                            isQuizEnded = true
                                        }
                                        randomQuizIndexes.shuffle()
                                    }

                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    .scaleEffect(2)
                            }
                        }
                        // VStack
                        .onAppear {
                            QuizService().getQuizzes { result in
                                switch result {
                                case .success(let data):
                                    quizzes = data.shuffled()
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            randomQuizIndexes.shuffle()
                        }
                    }
                    // ZStack
                    .frame(maxWidth: .infinity)
                }
                // VStack
            }
            // ZStack
        }
        // GeometryReader
        // 커스텀 뒤로가기 버튼 만들기
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.mode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "arrow.left")
                .font(Font.body.weight(.bold))
                .tint(.black)
        }))
        .gesture(DragGesture().updating($dragOffSet, body: { (value, _, _) in
            if value.startLocation.x < 20 && value.translation.width > 100 {
                self.mode.wrappedValue.dismiss()
            }
        }))
        .preferredColorScheme(.light)
    }

}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(isNavigationLinkActive: .constant(true))
    }
}
