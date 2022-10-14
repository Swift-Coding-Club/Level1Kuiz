//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI

struct QuizView: View {
    // PresentationMode는 Deprecated 될 예정이라 추후 수정 필요
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @GestureState private var dragOffSet = CGSize.zero

    //    @StateObject private var quizModel = QuizModel()

    @State var quizzes: [Quiz] = []
    @State var currentCount: Int = 0
    @State var correctCount: Int = 0

    @State var isQuizEnded: Bool = false

    @Binding var isNavigationLinkActive: Bool

    /**
     API 요청 한계를 넘겨 호출이 되지 않기 때문에
     임시 데이터 사용
     */
    @State var sampleQuizzes: [Quiz] = DataManager.share.getQuizzes()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: 100)
                Text(" 다음 중 맞는 것을 고르세요!")
                    .font(.title)
                    .fontWeight(.heavy)
                Text("\(currentCount) / \(sampleQuizzes.count)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(EdgeInsets(top: 1, leading: 0, bottom: 20, trailing: 0))
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    if !isQuizEnded {
                        Label(sampleQuizzes[currentCount].answers[0].text, systemImage: "circle")
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .font(Font.title3.bold())
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            .background(.white)
                            .cornerRadius(40, antialiased: true)
                            .shadow(radius: 1)
                            .onTapGesture {
                                if sampleQuizzes[currentCount].answers[0].isCorrect {
                                    correctCount += 1
                                }
                                currentCount += 1
                                if currentCount == sampleQuizzes.count {
                                    isQuizEnded = true
                                }
                            }
                        Label(sampleQuizzes[currentCount].answers[1].text, systemImage: "circle")
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .font(Font.title3.bold())
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                            .background(.white)
                            .cornerRadius(40, antialiased: true)
                            .shadow(radius: 1)
                            .onTapGesture {
                                if sampleQuizzes[currentCount].answers[0].isCorrect {
                                    correctCount += 1
                                }
                                currentCount += 1
                                if currentCount == sampleQuizzes.count {
                                    isQuizEnded = true
                                }
                            }
                    } else {
                        Text("모든 문제가 끝났습니다!")
                            .font(Font.title.bold())
                    }
                    Spacer()
                    if isQuizEnded {
                        NavigationLink(destination: ResultView(isNavigationLinkActive: $isNavigationLinkActive)) {
                            Text("결과 보기")
                                .font(.system(size: 20))
                                .fontWeight(.black)
                                .frame(width: 160, height: 60)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .cornerRadius(80)
                        }
                    } else {
                        HStack(spacing: 20) {
                            Button {

                            } label: {
                                Text("모르겠어요!")
                                    .font(.system(size: 20))
                                    .fontWeight(.black)
                                    .frame(width: 160, height: 60)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(80)
                            }

                            NavigationLink(destination: ResultView(isNavigationLinkActive: $isNavigationLinkActive)) {
                                Text("결과 보기")
                                    .font(.system(size: 20))
                                    .fontWeight(.black)
                                    .frame(width: 160, height: 60)
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(80)
                            }
                        }
                    }
                    Spacer()
                        .frame(height: 24)
                }
                .padding(.bottom, 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(60, corners: [.topLeft, .topRight])
                //                .shadow(radius: 5)
            }
            .ignoresSafeArea()
        }
        .background(Color.yellow)
        // 커스텀 뒤로가기 버튼 만들기
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
        .onAppear {
            //            quizzes = quizModel.data
            //            sampleQuizzes = dataManager.getQuizzes()
        }
        .preferredColorScheme(.light)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(isNavigationLinkActive: .constant(true))
    }
}
