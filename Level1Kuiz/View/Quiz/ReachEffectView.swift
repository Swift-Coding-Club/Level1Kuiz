//
//  ReachEffectView.swift
//  Level1Kuiz
//
//  Created by sueun kim on 10/8/23.
//

import SwiftUI
import ConfettiSwiftUI

struct ReachEffectView: View {
    @Binding var nowScore: Int
    @Binding var isEvent: Bool

    @State var scoreCounter: Int = 10
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(alignment: .center) {
                Spacer()
                Text("🎉축하합니다🎉")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                    .bold()
                    .padding()
                Text("당신은 \(Rank(score: nowScore).rawValue)!")
                    .foregroundStyle(.mint)
                    .font(.system(size: 50))
                    .bold()
                    .onAppear(perform: {
                        scoreCounter += 10
                    })
                Spacer()
                Button {
                    isEvent = false
                }label: {
                    Text("확인")
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                        .bold()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                                .frame(width: 200, height: 50)
                        )
                }
            }
            .confettiCannon(counter: $scoreCounter, num: 100, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
        }
    }
}
