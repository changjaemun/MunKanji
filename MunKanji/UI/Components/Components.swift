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
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        NavigationLink(value: value) {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(userSettings.currentMode.primaryColor)
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
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct NavyButton: View {
    let title: String
    let action: () -> Void
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        Button(action: action) {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(userSettings.currentMode.primaryColor)
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
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.backward")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.fontBlack)
        }
    }
}

struct KanjiCardView: View {
    let kanji: Kanji
    let studyLog: StudyLog
    @EnvironmentObject var userSettings: UserSettings

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
                .foregroundStyle(.white)
                .cornerRadius(20)
                .shadow(radius: 10, x: 4, y: 4)
            VStack(spacing:0){
                Rectangle()
                    .foregroundStyle(statusBarColor())
                    .frame(height: 20)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 20
                    ))
                Rectangle()
                    .foregroundStyle(.white)
                    .clipShape(UnevenRoundedRectangle(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 20, bottomTrailingRadius: 20, topTrailingRadius: 0
                    ))
            }
            VStack{
                Text(kanji.kanji)
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardBold(size: 80))
                Text(kanji.korean)
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardRegular(size: 24))
            }
        }.frame(width: 338, height: 230)
    }
}

struct KanjiWithExampleCardView: View {
    let kanji: Kanji
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(20)
                .shadow(radius: 10, x: 4, y: 4)
            VStack{
                VStack(spacing: 30){
                    VStack(spacing: 2){
                        Text(kanji.kanji)
                            .font(.pretendardBold(size: 64))
                            .foregroundStyle(userSettings.currentMode.primaryColor)
                        Text(kanji.korean)
                            .font(.pretendardRegular(size: 18))
                            .foregroundStyle(.fontBlack)
                    }
                    HStack(spacing: 50){
                        HStack(spacing: 14){
                            Text("음")
                                .foregroundStyle(.white)
                                .font(.pretendardRegular(size: 20))
                                .background{
                                    Rectangle()
                                        .foregroundStyle(userSettings.currentMode.primaryColor)
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(5)
                                }
                            Text(kanji.sound)
                                .font(.pretendardRegular(size: 24))

                        }
                        HStack(spacing: 14){
                            Text("훈")
                                .foregroundStyle(.white)
                                .font(.pretendardRegular(size: 20))
                                .background{
                                    Rectangle()
                                        .foregroundStyle(userSettings.currentMode.primaryColor)
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(5)
                                }
                            Text(kanji.meaning)
                                .font(.pretendardRegular(size: 24))
                        }
                    }
                }
            }
        }.frame(width: 338, height: 212)
    }
}

struct KanjiExampleRowView:View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray, lineWidth: 0.5)
            HStack{
                Spacer()
                Text("棟木")
                    .font(.pretendardRegular(size: 28))
                    //.border(.black)
                Spacer()
                Divider()
                    .padding(.vertical)
                VStack(alignment: .leading, spacing: 9){
                    Text("むなぎ")
                        .font(.pretendardMedium(size: 20))
                    Text("마룻대로 쓰는 목재")
                        .font(.pretendardLight(size: 12))
                        .foregroundStyle(.introFont)
                }.padding(.leading, 4)
                Spacer()
            }
        }.frame(width: 298, height: 70)
            .padding(4)
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

struct CountInfoRowView: View {
    let statusCircleColor: Color
    let count: Int
    let title: String
    @EnvironmentObject var userSettings: UserSettings

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
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardSemiBold(size: 24))
                Text("개")
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardLight(size: 24))
            }
        }.padding(.horizontal, 40)
    }
}

#Preview(body: {
    ZStack{
        Color.gray
        KanjiWithExampleCardView(kanji: Dummy.kanji)
    }.ignoresSafeArea()
})

#Preview(body: {
    KanjiExampleRowView()
})

