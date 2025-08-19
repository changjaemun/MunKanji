//
//  StudyIntro.swift
//  MunKanji
//
//  Created by 문창재 on 8/19/25.
//

import SwiftUI

struct StudyIntroCountInfoRowView:View {
    let statusCircleColor:Color
    let count:Int
    let title:String
    
    var body: some View {
        HStack{
            Circle()
                .fill(statusCircleColor)
                .frame(width: 12)
                .padding(.trailing, 10)
            Text("\(title)")
                .modifier(StudyIntroTextStyle())
            Spacer()
            HStack(spacing: 4) {
                    Text("\(count)")
                        .foregroundStyle(.main)
                        .font(.pretendardSemiBold(size: 24))
                    Text("개")
                        .foregroundStyle(.main)
                        .font(.pretendardLight(size: 24))
                }
        }.padding(.horizontal, 40)
    }
}


