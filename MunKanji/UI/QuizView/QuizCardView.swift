//
//  QuizCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI

struct QuizCardView: View {
    let answer: String
    let korean: String
    @State var isCorrected:StudyStatus = .unseen
    
    var body: some View {
        Button{
            
            // 채점
            if answer == korean{
                isCorrected = .correct
            }else{
                isCorrected = .incorrect
            }
            
            // 눌렀을 때 오답 3개 셔플
            // 1초 후 인덱스 +1
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(isCorrected == .unseen ? .miniCard : isCorrected == .correct ? .accent : .red)
                  .frame(width: 160, height: 160)
                  .cornerRadius(20)
                  .shadow(radius: 5)
                Text(korean)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.main)
            }
        }.buttonStyle(.plain)
        
    }
}

