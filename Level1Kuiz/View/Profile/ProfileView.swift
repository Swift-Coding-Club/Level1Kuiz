//
//  ProfileView.swift
//  Level1Kuiz
//
//  Created by Claude on 2025/11/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var userDataManager = UserDataManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var editingUsername = false
    @State private var tempUsername = ""

    let avatarOptions = [
        "person.circle.fill", "person.crop.circle.fill", "face.smiling.fill",
        "star.circle.fill", "crown.fill", "book.circle.fill",
        "pencil.circle.fill", "brain.head.profile", "graduationcap.circle.fill"
    ]

    var unlockedTitles: [String] {
        var titles = [""]
        titles += userDataManager.achievements
            .filter { $0.isUnlocked }
            .map { $0.type.title }
        return titles
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.95, blue: 0.98)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // 아바타 선택
                        VStack(spacing: 15) {
                            Text("아바타")
                                .font(.system(size: 18, weight: .bold))

                            Image(systemName: userDataManager.selectedAvatar)
                                .font(.system(size: 100))
                                .foregroundColor(.blue)
                                .frame(width: 150, height: 150)
                                .background(Color.blue.opacity(0.1))
                                .clipShape(Circle())

                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                                ForEach(avatarOptions, id: \.self) { avatar in
                                    Button(action: {
                                        userDataManager.selectedAvatar = avatar
                                        userDataManager.saveData()
                                    }) {
                                        Image(systemName: avatar)
                                            .font(.system(size: 30))
                                            .foregroundColor(userDataManager.selectedAvatar == avatar ? .blue : .gray)
                                            .frame(width: 60, height: 60)
                                            .background(userDataManager.selectedAvatar == avatar ? Color.blue.opacity(0.2) : Color.white)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(userDataManager.selectedAvatar == avatar ? Color.blue : Color.clear, lineWidth: 3)
                                            )
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)

                        // 닉네임 설정
                        VStack(spacing: 15) {
                            Text("닉네임")
                                .font(.system(size: 18, weight: .bold))

                            if editingUsername {
                                HStack {
                                    TextField("닉네임 입력", text: $tempUsername)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .font(.system(size: 16))

                                    Button("저장") {
                                        if !tempUsername.isEmpty {
                                            userDataManager.username = tempUsername
                                            userDataManager.saveData()
                                        }
                                        editingUsername = false
                                    }
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.blue)
                                }
                            } else {
                                HStack {
                                    Text(userDataManager.username)
                                        .font(.system(size: 20, weight: .bold))

                                    Spacer()

                                    Button(action: {
                                        tempUsername = userDataManager.username
                                        editingUsername = true
                                    }) {
                                        Text("수정")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)

                        // 칭호 선택
                        VStack(spacing: 15) {
                            Text("칭호")
                                .font(.system(size: 18, weight: .bold))

                            VStack(spacing: 10) {
                                ForEach(unlockedTitles, id: \.self) { title in
                                    Button(action: {
                                        userDataManager.selectedTitle = title
                                        userDataManager.saveData()
                                    }) {
                                        HStack {
                                            if title.isEmpty {
                                                Text("칭호 없음")
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text(title)
                                                    .foregroundColor(.black)
                                            }

                                            Spacer()

                                            if userDataManager.selectedTitle == title {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding(15)
                                        .background(userDataManager.selectedTitle == title ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)

                        Spacer(minLength: 30)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("프로필 설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
