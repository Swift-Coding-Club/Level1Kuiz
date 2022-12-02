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
    @State private var isNavigationLinkActive = false
    @State private var timer = Timer.publish(every: TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
    @State private var answers: [Quiz.Answer] = [
        Quiz.Answer(text: "한글 날", isCorrect: false),
        Quiz.Answer(text: "한글날", isCorrect: true)
    ]

    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(answers, id: \.text) { answer in
                            Text("\(answer.text) (\(answer.isCorrect ? "O" : "X"))")
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .transition(.offset(x: 0, y: 300))
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }

                GeometryReader { geometry in
                    VStack {
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Level1Kuiz")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                Text("Swift Coding Club 1기 Level 1 Korean Quiz")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            Text("심심할 때 띄어쓰기 한판 어떠세요?\n풀면 풀수록 재밌는 띄어쓰기 문제!\n지금 바로 시작해 보세요 😎")
                        }

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
        }
        .onChange(of: isNavigationLinkActive, perform: { isActive in
            if isActive {
                timer.upstream.connect().cancel()
            } else {
                timer = Timer.publish(every: HomeView.TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
            }
        })
        .onReceive(timer) { _ in
            if quizExamplesModel.data.isEmpty {
                return
            }

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
