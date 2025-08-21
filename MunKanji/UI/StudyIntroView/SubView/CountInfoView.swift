//
//  CountInfoView.swift
//  MunKanji
//
//  Created by 문창재 on 8/19/25.
//
import SwiftUI

struct StudyInfoCountInfoView: View {
    let inCorrectKanjisCount: Int
    let reviewKanjisCount: Int
    let unseenKanjisCount: Int
    
    var body: some View {
        ZStack{
            Rectangle()
                .modifier(CardStyle())
            GeometryReader{ geo in
                VStack(alignment: .leading, spacing: 22) {
                    Spacer()
                    CountInfoRowView(statusCircleColor: .incorrect, count: inCorrectKanjisCount, title: "틀렸던 한자")
                    CountInfoRowView(statusCircleColor: .point, count: reviewKanjisCount, title: "리뷰할 한자")
                    CountInfoRowView(statusCircleColor: .main, count: unseenKanjisCount, title: "새로운 한자")
                    Spacer()
                }
            }
        }.frame(width: 331, height: 222)
    }
}
