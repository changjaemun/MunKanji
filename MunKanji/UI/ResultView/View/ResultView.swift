//
//  ResultView.swift
//  MunKanji
//
//  Created by 문창재 on 6/16/25.
//

import SwiftUI

struct ResultView: View {
    @Binding var path: NavigationPath

    let results: [QuizResult]
    let learningKanjis: [Kanji]
    
    private var correctCount: Int {
        results.filter { $0.newStatus == .correct }.count
    }
    
    private var incorrectCount: Int {
        results.filter { $0.newStatus == .incorrect }.count
    }
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            VStack {
                Text("학습결과")
                    .foregroundStyle(.main)
                    .font(.pretendardBold(size: 28))
                    .padding(.top, 60)
                Spacer()
                // 결과 카드
                VStack(spacing: 24) {
                    ResultRowView(
                        circleColor: .review,
                        title: "맞힌 한자",
                        count: correctCount
                    )
                    ResultRowView(
                        circleColor: .incorrect,
                        title: "틀린 한자",
                        count: incorrectCount
                    )
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 36)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 80)

                Spacer()
                NavyButton(title: "완료") {
                    path = NavigationPath()
                }
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - 결과 행
private struct ResultRowView: View {
    let circleColor: Color
    let title: String
    let count: Int

    var body: some View {
        HStack {
            Circle()
                .fill(circleColor)
                .frame(width: 12)
                .padding(.trailing, 10)
            Text(title)
                .foregroundStyle(.introFont)
                .font(.pretendardRegular(size: 24))
            Spacer()
            HStack(spacing: 4) {
                Text("\(count)")
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardSemiBold(size: 24))
                    .frame(minWidth: 28, alignment: .trailing)
                Text("개")
                    .foregroundStyle(.fontBlack)
                    .font(.pretendardLight(size: 24))
            }
        }
    }
}

#Preview("결과 - 혼합") {
    @Previewable @State var path = NavigationPath()
    let results = [
        QuizResult(kanjiID: 0, newStatus: .correct),
        QuizResult(kanjiID: 1, newStatus: .correct),
        QuizResult(kanjiID: 2, newStatus: .incorrect),
        QuizResult(kanjiID: 3, newStatus: .correct),
        QuizResult(kanjiID: 4, newStatus: .incorrect)
    ]
    let kanjis = [
        Kanji(id: 0, grade: "소학교 1학년", kanji: "車", korean: "수레 차", sound: "しゃ", meaning: "くるま"),
        Kanji(id: 1, grade: "소학교 1학년", kanji: "犬", korean: "개 견", sound: "けん", meaning: "いぬ"),
        Kanji(id: 2, grade: "소학교 1학년", kanji: "見", korean: "볼 견", sound: "けん", meaning: "みる"),
        Kanji(id: 3, grade: "소학교 1학년", kanji: "月", korean: "달 월", sound: "げつ", meaning: "つき"),
        Kanji(id: 4, grade: "소학교 1학년", kanji: "花", korean: "꽃 화", sound: "か", meaning: "はな")
    ]
    ResultView(path: $path, results: results, learningKanjis: kanjis)
        .environmentObject(UserSettings())
}

#Preview("결과 - 전부 정답") {
    @Previewable @State var path = NavigationPath()
    let results = [
        QuizResult(kanjiID: 0, newStatus: .correct),
        QuizResult(kanjiID: 1, newStatus: .correct),
        QuizResult(kanjiID: 2, newStatus: .correct)
    ]
    ResultView(path: $path, results: results, learningKanjis: [])
        .environmentObject(UserSettings())
}
