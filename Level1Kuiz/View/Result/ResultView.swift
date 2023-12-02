//
//  ResultView.swift
//  Level1Kuiz
//
//  Created by 황석현 on 2022/10/21.
//

import SwiftUI
import SwiftUIMargin

struct ResultView: View {

    var score: Int
    var answer: String
    var description: String
    var scoreColor: Color
    var maxScore: Int = 40

    static let TRANSITION_TIME_INTERVAL: TimeInterval = 0.1

    @State private var isNavigationLinkActive = false
    @State private var timer = Timer.publish(every: TRANSITION_TIME_INTERVAL, on: .main, in: .common).autoconnect()
    @State var dynamicScore: Int = 0
    @State private var showShareSheet = false
    @State private var imageToShare: UIImage?

    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack(alignment: .center, spacing: 8) {
                    Text(dynamicScore.description)
                        .font(.system(size: 80))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                    //                    Text(getRankByScore(with: score).rawValue)
                    Text("\(Rank(score: score).rawValue)")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(answer)")
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("\(description)")
                            .foregroundColor(Color.gray)
                    }
                    .margin(top: 40)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 40))
                .frame(width: geometry.size.width, height: geometry.size.height)
            }

            GeometryReader { geometry in
                VStack {
                    VStack(spacing: 24) {
                        if Rank(score: score) == Rank.expert {
                            Text("이렇게 높은 점수가 나오다니 당신의 직업이 궁금하군요! 우리말 겨루기에 도전해 보는 건 어떠세요?")
                                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            NavigationLink(destination: HomeView(), isActive: $isNavigationLinkActive) {
                                Button {
                                    isNavigationLinkActive = true
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
                            if score == maxScore {
                                Text("당신은 \(Rank(score: score).rawValue)!!")
                            } else {
                                Text("\(Rank(score: score + 10).rawValue) 등급까지 \(Rank(score: score).getRemainScore(score: score))문제 남았어요.")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("더 높은 등급에 도전해 보세요!")
                            }

                            NavigationLink(destination: QuizView(), isActive: $isNavigationLinkActive) {
                                Button {
                                    isNavigationLinkActive = true
                                } label: {
                                    Text("다시 도전하기")
                                        .font(.system(size: 20))
                                        .fontWeight(.black)
                                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                                        .foregroundColor(Color.white)
                                        .background(Color.black)
                                        .cornerRadius(80)
                                }
                            }
                            .navigationBarBackButtonHidden(true)

                            .sheet(isPresented: $showShareSheet) {
                                ShareSheet(items: [imageToShare])
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 60, leading: 40, bottom: 60, trailing: 40))
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(scoreColor)
                .cornerRadius(60, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.all)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    let message = "\(Rank(score: score + 10).rawValue) 등급까지 \(Rank(score: score).getRemainScore(score: score))문제 남았어요."
                    let renderer = ImageRenderer(content: ShareView(score: dynamicScore.description,
                                                                    rank: Rank(score: score).rawValue,
                                                                    message: message).frame(width: 400, height: 400))

                    if let uiImage = renderer.uiImage {
                        imageToShare = uiImage
                        if let _ = imageToShare {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showShareSheet.toggle()
                            }
                        }
                    }

                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.black)
                }
            }
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
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ResultView(
                score: 10,
                answer: "",
                description: "",
                scoreColor: Color.yellow
            )
        }
    }
}
