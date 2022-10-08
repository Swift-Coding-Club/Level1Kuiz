//
//  HomeView.swift
//  Level1Kuiz
//
//  Created by 백은주 on 2022/10/01.
//

import SwiftUI

struct HomeView: View {
    @State private var quizzes: [Quiz] = []

    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            VStack {
                Text(quizzes.description)
                HStack {
                    Button {
                        // @스뇽
                        QuizService().getQuizzes { result in
                            switch result {
                            case .success(let data):
                                quizzes = data
                            case .failure(let error):
                                print(error)
                            }
                        }
                    } label: {
                        Text("퀴즈 목록 조회")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
