//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI

struct KuizView: View {

    var body: some View {

        VStack(spacing: 20) {
            Label("현재 문재 몇 번째인지 알려주기", systemImage: "circle" )
            Text("다음 중 맞는 것을 고르세요!")
            Button {

            } label: {
                HStack {
                    Text("placeholder")
                }
            }
            Button {

            } label: {
                HStack {
                    Text("placeholder")
                }
            }

        
        }
    }
}

struct KuizView_Previews: PreviewProvider {
    static var previews: some View {
        KuizView()
    }
}
