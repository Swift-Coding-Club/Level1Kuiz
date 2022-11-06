//
//  ResultView.swift
//  Level1Kuiz
//
//  Created by 황석현 on 2022/10/21.
//

import SwiftUI

struct ResultView: View {

    @Binding var isNavigationLinkActive: Bool
    @State var userName: String = ""
    var correctCount: Int

    @State var saveUserID: String = ""
    @State var userName: Array = [""]
    @State var userScore: Array = []
    @State var toggle: Bool = true

    var body: some View {
        VStack {
            Text("퀴즈가 끝났어요!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()

            Text("점수는 \(correctCount)")
                .font(.title2)
                .fontWeight(.heavy)
                .padding()

            //  유저ID 저장하기 개발 중
            HStack(alignment: .center, spacing: 10) {
                TextField("저장할까요?", text: $saveUserID)
                    .frame(width: 120, height: 40, alignment: .center)
                    .font(.system(size: 22))
                    .autocorrectionDisabled(true)
                Button {
                    // 유저이름 저장
                    userName.append(saveUserID)
                    // 유저의 점수 저장
//                  userScore.append(currentCount)

                } label: {
                    Text("저장하기!")
                        .font(.system(size: 20))
                        .bold()
                }
            }
            .padding()

            NavigationLink(destination: QuizView(isNavigationLinkActive: $isNavigationLinkActive)) {
                Button {
                    isNavigationLinkActive = false
                } label: {
                    Text("홈으로 가기")
                        .font(.system(size: 20))
                        .fontWeight(.black)
                        .frame(width: 160, height: 60)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(80)
                }
                NavigationLink(destination: ScoreView()) {
                    Text("기록 보기")
                        .font(.system(size: 20))
                        .fontWeight(.black)
                        .frame(width: 160, height: 60)
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(80)
                    }

            }.navigationBarBackButtonHidden(true)

        }.frame(width: 380, height: 400)
            .background(Color.yellow)
            .cornerRadius(80)
            .padding()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(isNavigationLinkActive: .constant(true), correctCount: 0)
    }
}
