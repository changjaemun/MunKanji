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
    var showStatusBar: Bool = true
    @EnvironmentObject var userSettings: UserSettings

    var statusColor: Color {
        if studyLog.status == .incorrect {
            return .incorrect
        }
        if let nextReviewDate = studyLog.nextReviewDate, nextReviewDate <= Date() {
            return .review
        }
        return .newKanji
    }

    var body: some View {
        VStack(spacing: 0) {
            // 상단 상태바
            if showStatusBar {
                Rectangle()
                    .fill(statusColor)
                    .frame(height: 8)
            }

            // 메인 콘텐츠
            VStack(spacing: 0) {
                Spacer()

                // 한자
                Text(kanji.kanji)
                    .font(.pretendardBold(size: 80))
                    .foregroundStyle(.fontBlack)

                // 뜻 (한국어)
                Text(kanji.korean)
                    .font(.pretendardMedium(size: 22))
                    .foregroundStyle(.fontBlack)
                    .multilineTextAlignment(.center)

                Spacer()

                // memoryTip
                if let tip = kanji.memoryTip, !tip.isEmpty {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 1)
                        .padding(.horizontal, 24)

                    Text(tip)
                        .font(.pretendardRegular(size: 14))
                        .foregroundStyle(.fontGray)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
        .frame(width: 338, height: kanji.memoryTip?.isEmpty == false ? 280 : 230)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    }
}

struct KanjiWithExampleCardView: View {
    let kanji: Kanji
    var statusColor: Color? = nil
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack(spacing: 0) {
            // 상단 색띠
            if let color = statusColor {
                Rectangle()
                    .fill(color)
                    .frame(height: 8)
            }

            // 메인 콘텐츠: 왼쪽 한자 | 오른쪽 음훈
            HStack(spacing: 0) {
                // 왼쪽: 한자 + 뜻
                VStack(spacing: 4) {
                    Text(kanji.kanji)
                        .font(.pretendardBold(size: 64))
                        .foregroundStyle(.fontBlack)
                    Text(kanji.korean)
                        .font(.pretendardRegular(size: 14))
                        .foregroundStyle(.fontGray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(width: 140)

                // 구분선 (단어리스트 구분선과 동일 스타일)
                Rectangle()
                    .fill(Color.gray.opacity(0.25))
                    .frame(width: 1, height: 40)

                // 오른쪽: 음/훈
                VStack(alignment: .leading, spacing: 20) {
                    // 음
                    HStack(alignment: .top, spacing: 8) {
                        Text("음")
                            .foregroundStyle(.white)
                            .font(.pretendardRegular(size: 14))
                            .frame(width: 24, height: 24)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.fontBlack)
                            )
                        Text(kanji.sound)
                            .font(.pretendardRegular(size: 16))
                            .foregroundStyle(.fontBlack)
                    }
                    // 훈
                    HStack(alignment: .top, spacing: 8) {
                        Text("훈")
                            .foregroundStyle(.white)
                            .font(.pretendardRegular(size: 14))
                            .frame(width: 24, height: 24)
                            .background(
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.fontBlack)
                            )
                        Text(kanji.meaning)
                            .font(.pretendardRegular(size: 16))
                            .foregroundStyle(.fontBlack)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
        .frame(width: 338, height: 190)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
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

// MARK: - KanjiCardView Preview
#Preview("KanjiCardView - 상태별") {
    ScrollView {
        VStack(spacing: 20) {
            Text("신규 (파랑)")
                .font(.caption)
            KanjiCardView(kanji: Dummy.kanjiWithTip, studyLog: Dummy.studyLogUnseen)

            Text("복습 (초록)")
                .font(.caption)
            KanjiCardView(kanji: Dummy.kanjiWithTip, studyLog: Dummy.studyLogCorrect)

            Text("틀림 (코랄)")
                .font(.caption)
            KanjiCardView(kanji: Dummy.kanjiWithTip, studyLog: Dummy.studyLogIncorrect)

            Text("팁 없음")
                .font(.caption)
            KanjiCardView(kanji: Dummy.kanji, studyLog: Dummy.studyLogUnseen)
        }
        .padding()
    }
    .background(Color.backGround)
    .environmentObject(UserSettings())
}

#Preview("KanjiWithExampleCardView") {
    ZStack {
        Color.gray
        KanjiWithExampleCardView(kanji: Dummy.kanji)
    }
    .ignoresSafeArea()
    .environmentObject(UserSettings())
}


