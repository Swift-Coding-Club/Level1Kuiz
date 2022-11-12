//
//  ResultView.swift
//  Level1Kuiz
//
//  Created by 황석현 on 2022/10/21.
//

import SwiftUI

struct ResultView: View {

    @Binding var isNavigationLinkActive: Bool
    var score: Int

    static let TRANSITION_TIME_INTERVAL: TimeInterval = 0.1

    @State private var timer = Timer.publish(every: TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
    @State var dynamicScore: Int = 0

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 8) {
                    Text(dynamicScore.description)
                        .font(.system(size: 80))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    Text(getRankByScore(with: score).rawValue)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                .frame(width: geometry.size.width, height: geometry.size.height)
            }

            GeometryReader { geometry in
                VStack {
                    VStack(spacing: 24) {
                        if getRankByScore(with: score) == Rank.expert {
                            Text("이렇게 높은 점수가 나오다니 당신의 직업이 궁금하군요! 우리말 겨루기에 도전해 보는 건 어떠세요?")
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            NavigationLink(destination: HomeView()) {
                                Button {
                                    isNavigationLinkActive = false
                                } label: {
                                    Text("홈")
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .frame(width: 160)
                                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                                        .foregroundColor(Color.white)
                                        .background(Color.black)
                                        .cornerRadius(80)
                                }
                            }
                            .navigationBarBackButtonHidden(true)
                        } else {
                            Text("더 높은 등급에 도전해 보세요!")
                            NavigationLink(destination: QuizView(isNavigationLinkActive: $isNavigationLinkActive)) {
                                Button {
                                    isNavigationLinkActive = false
                                } label: {
                                    Text("\(getRankByScore(with: score + 10).rawValue) 도전")
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                                        .foregroundColor(Color.white)
                                        .background(Color.black)
                                        .cornerRadius(80)
                                }
                            }
                            .navigationBarBackButtonHidden(true)
                        }
                    }
                }
                .padding(EdgeInsets(top: 60, leading: 40, bottom: 60, trailing: 40))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.yellow)
                .cornerRadius(60, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: isNavigationLinkActive, perform: { isActive in
            if isActive {
                timer.upstream.connect().cancel()
            } else {
                timer = Timer.publish(every: ResultView.TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
            }
        })
        .onReceive(timer) { _ in
            if dynamicScore == score {
                timer.upstream.connect().cancel()
                return
            }

            dynamicScore += 1
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

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(isNavigationLinkActive: .constant(true), score: 10)
    }
}
