//
//  Components.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI


struct NavyNavigationLink<Value: Hashable>: View {
    let title: String
    let value: Value
    
    var body: some View {
        NavigationLink(value: value) {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(.main)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .foregroundStyle(.white)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct GrayNavigationLink<Value: Hashable>: View {
    let title: String
    let value: Value
    
    var body: some View {
        NavigationLink(value: value) {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 60)
                    .foregroundStyle(.backGround)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .foregroundStyle(.black)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct NavyButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(.main)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text(title)
                    .foregroundStyle(.white)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button(action: {dismiss()}){
            ZStack{
                Rectangle()
                    .foregroundStyle(.clear)
                Image(systemName: "chevron.left")
                    .resizable()
                    .foregroundStyle(.accent)
            }
        }
    }
}

struct KanjiCardView: View {
    let kanji: Kanji
    let studyLog: StudyLog
    
    func statusBarColor() -> Color {
        if studyLog.status == .incorrect {
            return .incorrect
        }
        if let nextReviewDate = studyLog.nextReviewDate, nextReviewDate <= Date() {
            return .point
        }
        return .white
    }
    
    var body: some View {
                ZStack{
                    Rectangle()
                        .frame(width: 338, height: 360)
                        .modifier(CardStyle())
                    VStack{
                        Rectangle()
                            .foregroundStyle(statusBarColor())
                            .frame(width: 338, height: 24)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        Spacer()
                    }.frame(height: 360)
                    VStack{
                        VStack{
                            Text(kanji.kanji)
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 80))
                            Text(kanji.korean)
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                        }.frame(width: 338)
                            .padding(.bottom, 30)
                        Divider()
                            .frame(width: 310)
                        HStack{
                            VStack(alignment:.leading, spacing: 20){
                                Text("음: \(kanji.sound)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                                Text("훈: \(kanji.meaning)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                            }.padding(.horizontal)
                            Spacer()
                        }.padding()
                        
                    }.frame(width: 338, height: 388)
                    
                }
        }
    }

struct MiniKanjiCardView: View {
    let kanji: Kanji
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
              .frame(width: 105, height: 97)
              .cornerRadius(20)
              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            Text(kanji.kanji)
                .font(.pretendardRegular(size: 40))
        }
    }
}

struct CountInfoRowView:View {
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

