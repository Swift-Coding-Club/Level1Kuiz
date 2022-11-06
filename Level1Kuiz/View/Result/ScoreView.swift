//
//  ScoreView.swift
//  Level1Kuiz
//
//  Created by 황석현 on 2022/10/28.
//

import SwiftUI

struct ScoreView: View {

    var body: some View {
        VStack {
            Text("당신은 몇 등인가요?")
                .font(.system(size: 35))
                .fontWeight(.black)
                .frame(width: 400, height: 60)
                .foregroundColor(Color.black)

            ScrollView {
                VStack {
                    HStack {
                        // 순위표시 (숫자)
                        Text("")
                            .font(.system(size: 20))
                            .fontWeight(.black)
                            .frame(width: 400, height: 60)
                            .foregroundColor(Color.black)
                            .padding()
                        // UserID 표시 (문자)
                        Text("")
                            .font(.system(size: 20))
                            .fontWeight(.black)
                            .frame(width: 400, height: 60)
                            .foregroundColor(Color.black)
                            .padding()
                        // UserScore 표시 (숫자)
                        Text("")
                            .font(.system(size: 20))
                            .fontWeight(.black)
                            .frame(width: 400, height: 60)
                            .foregroundColor(Color.black)
                            .padding()
                    }
                }

            }
            .frame(width: 400, height: .infinity)
            .background(Color.yellow)
            .cornerRadius(65)
            .ignoresSafeArea()

        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
