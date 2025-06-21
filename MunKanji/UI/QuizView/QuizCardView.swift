//
//  QuizCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI

struct QuizCardView: View {
    let korean: String
    @State var touched: Bool = false
    
    var body: some View {
        Button{
            // 선택 됨
            touched.toggle()
            // 채점로직
        }label: {
            ZStack{
                Rectangle()
                    .foregroundStyle(touched ? .main:.miniCard)
                  .frame(width: 160, height: 160)
                  .cornerRadius(20)
                  .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(korean)
                    .font(.pretendardSemiBold(size: 24))
                    .foregroundStyle(touched ? .miniCard : .main)
            }
        }.buttonStyle(.plain)
        
    }
}

