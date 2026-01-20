//
//  WrongAnswerView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI

struct WrongAnswerView: View {
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingQuiz = false
    @State private var selectedWrongAnswer: WrongAnswer?

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.98)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Text("오답 노트")
                        .font(.system(size: 28, weight: .bold))

                    Spacer()

                    Spacer()
                        .frame(width: 44)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 15)

                if userDataManager.wrongAnswers.isEmpty {
                    Spacer()
                    VStack(spacing: 15) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.green)

                        Text("오답이 없습니다!")
                            .font(.system(size: 24, weight: .bold))

                        Text("완벽한 실력이네요!")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(userDataManager.wrongAnswers) { wrongAnswer in
                                WrongAnswerCard(wrongAnswer: wrongAnswer) {
                                    userDataManager.removeWrongAnswer(wrongAnswer.id)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct WrongAnswerCard: View {
    let wrongAnswer: WrongAnswer
    let onDelete: () -> Void
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(wrongAnswer.date, style: .date)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)

                Spacer()

                if wrongAnswer.reviewCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                            .font(.system(size: 10))
                        Text("\(wrongAnswer.reviewCount)회 복습")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.blue)
                }

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                }
            }

            Divider()

            // 문제
            VStack(alignment: .leading, spacing: 8) {
                Text("문제")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)

                HStack(spacing: 8) {
                    Text(wrongAnswer.quiz.answers[0].text)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(wrongAnswer.userAnswer == wrongAnswer.quiz.answers[0].text ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    Text(wrongAnswer.quiz.answers[1].text)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(wrongAnswer.userAnswer == wrongAnswer.quiz.answers[1].text ? Color.red.opacity(0.2) : Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
            }

            // 정답 표시
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                Text("정답:")
                    .font(.system(size: 14, weight: .semibold))
                Text(wrongAnswer.correctAnswer)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
            }

            // 해설 보기 버튼
            Button(action: {
                showDetail.toggle()
                if showDetail {
                    UserDataManager.shared.incrementReviewCount(wrongAnswer.id)
                }
            }) {
                HStack {
                    Image(systemName: showDetail ? "chevron.up" : "chevron.down")
                    Text(showDetail ? "해설 숨기기" : "해설 보기")
                        .font(.system(size: 14, weight: .semibold))
                }
                .foregroundColor(.blue)
            }

            if showDetail {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                    Text("해설")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    Text(wrongAnswer.quiz.description)
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
