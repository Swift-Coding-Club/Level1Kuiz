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

    var body: some View {
        VStack {
            Text("퀴즈가 끝났어요!")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding()

            Text("점수는 0")
                .font(.title2)
                .fontWeight(.heavy)
                .padding()

            HStack(alignment: .center, spacing: 10) {
                TextField("저장하시겠습니까?", text: $userName)
                    .frame(width: 150, height: 30, alignment: .center)
                Button {
                } label: {
                    Text("저장하기")
                        .font(.system(size: 17))
                }
            }.padding()

            NavigationLink(destination: QuizView(isNavigationLinkActive: $isNavigationLinkActive), isActive: $isNavigationLinkActive) {
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

            }

        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(isNavigationLinkActive: .constant(true))
    }
}
