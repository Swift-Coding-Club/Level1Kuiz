//
//  Result.swift
//  Level1Kuiz
//
//  Created by 황석현 on 2022/09/25.
//

import SwiftUI

struct Result: View {
    
    @State var name: String = ""
    var score: Int = 0
    var Correct: String = "0"
    
    
    var body: some View {
        VStack {
            
            HStack(spacing: 10){
                Image(systemName:"star.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                Text("Kuiz가 끝났습니다!")
                    .font(.largeTitle)
            
                Image(systemName:"star.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
                .frame(height: 30)
            
            //틀린 문제에 대한 정답 가져오기
            Text("정답은 \(Correct)")
                .font(.headline)
            Spacer()
                .frame(height: 10)
            
            //정답풀이(필요하다면)
//            Text("정답풀이")
//                .font(.subheadline)
//            Spacer()
//                .frame(height: 50)
//
            //점수 출력, 저장하기
            Text("점수는 \(score)입니다. 저장하시겠습니까?")
                .font(.title2)
            Spacer()
                .frame(height: 10)
            
            //기록 저장
            TextField("이름을 입력하세요!", text: $name)
                .frame(width: 100,height: 10, alignment: .center)
            Spacer()
                .frame(height: 30)
            
            HStack{
                Button("다시하기") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
                Button("홈으로") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
            }
        }
    }
}

struct Result_Previews: PreviewProvider {
    static var previews: some View {
        Result()
    }
}

