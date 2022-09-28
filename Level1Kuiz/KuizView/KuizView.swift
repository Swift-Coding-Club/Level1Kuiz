//
//  QuizView.swift
//  Level1Kuiz
//
//  Created by 권승용 on 2022/09/26.
//

import SwiftUI

struct KuizView: View {

    @State private var correctCount: Int = 0
    @State private var currentCount: Int = 0

    let sampleData = DataManager.share.getData()

    @State private var randomFlag: Int = Int.random(in: 0...1)

    var body: some View {

        VStack(spacing: 50) {
            
            Text(String(correctCount) + "/" + String(sampleData.count))
            VStack(spacing: 20) {

                Text("다음 중 맞는 것을 고르세요!")
                
                if let quizString = sampleData[currentCount].quizString {
                    Text(quizString)
                }
                
                if randomFlag == 0 {
                    HStack {
                        Button {
                            randomFlag = Int.random(in: 0...1)
                            correctCount += 1
                            currentCount += 1
                        } label: {
                            Text(sampleData[currentCount].correctAnswer)
                        }

                        Button {
                            randomFlag = Int.random(in: 0...1)
                            currentCount += 1
                        } label: {
                            Text(sampleData[currentCount].wrongAnswer)
                        }
                    }
                } else {
                    HStack {
                        Button {
                            randomFlag = Int.random(in: 0...1)
                            currentCount += 1
                        } label: {
                            Text(sampleData[currentCount].wrongAnswer)
                        }

                        Button {
                            randomFlag = Int.random(in: 0...1)
                            correctCount += 1
                            currentCount += 1
                        } label: {
                            Text(sampleData[currentCount].correctAnswer)
                        }
                    }
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
