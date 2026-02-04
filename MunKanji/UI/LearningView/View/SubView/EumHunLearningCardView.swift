//
//  EumHunLearningCardView.swift
//  MunKanji
//
//  Created by 문창재 on 1/27/26.
//

import SwiftUI
import SwiftData

struct EumHunLearningCardView: View {
    let learningKanjis: [Kanji]
    @State private var currentIndex: Int = 0
    @EnvironmentObject var userSettings: UserSettings
    @Query private var kanjiExamples: [KanjiWithExampleWords]
    @Query private var eumhunStudyLogs: [EumHunStudyLog]

    private func statusColor(for kanjiID: Int) -> Color {
        guard let log = eumhunStudyLogs.first(where: { $0.kanjiID == kanjiID }) else {
            return .newKanji
        }
        if log.status == .incorrect {
            return .incorrect
        }
        if let nextReviewDate = log.nextReviewDate, nextReviewDate <= Date() {
            return .review
        }
        return .newKanji
    }

    private var currentKanji: Kanji? {
        guard currentIndex < learningKanjis.count else { return nil }
        return learningKanjis[currentIndex]
    }

    private var currentExamples: [ExampleData] {
        guard let kanji = currentKanji,
              let kanjiExample = kanjiExamples.first(where: { $0.kanjiID == kanji.id }) else {
            return []
        }
        return kanjiExample.examples
    }

    var body: some View {
        VStack(spacing: 0) {
            // Kanji Card Carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(learningKanjis.enumerated()), id: \.element.id) { index, kanji in
                    KanjiWithExampleCardView(kanji: kanji, statusColor: statusColor(for: kanji.id))
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 220)

            // 카드 ↔ 단어리스트 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.top, 8)

            // Example Words List
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 8) {
                        Color.clear
                            .frame(height: 0)
                            .id("scrollTop")

                        ForEach(Array(currentExamples.enumerated()), id: \.offset) { _, example in
                            KanjiExampleRowView(example: example)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                }
                .onChange(of: currentIndex) {
                    withAnimation {
                        proxy.scrollTo("scrollTop", anchor: .top)
                    }
                }
            }
        }
    }
}

// MARK: - KanjiExampleRowView
struct KanjiExampleRowView: View {
    var example: ExampleData? = nil

    private var word: String {
        example?.word ?? "棟木"
    }

    private var sound: String {
        example?.sound ?? "むなぎ"
    }

    private var meaning: String {
        example?.meaning ?? "마룻대로 쓰는 목재"
    }

    var body: some View {
        HStack(spacing: 0) {
            // 왼쪽: 단어 (고정 너비)
            Text(word)
                .font(.pretendardRegular(size: 28))
                .foregroundStyle(.fontBlack)
                .frame(width: 140)

            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(width: 1, height: 40)

            // 오른쪽: 발음 + 뜻 (나머지 공간)
            VStack(alignment: .leading, spacing: 6) {
                Text(sound)
                    .font(.pretendardMedium(size: 20))
                    .foregroundStyle(.fontBlack)
                Text(meaning)
                    .font(.pretendardLight(size: 12))
                    .foregroundStyle(.introFont)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 16)
        }
        .padding(.horizontal, 16)
        .frame(width: 338, height: 70)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        )
    }
}

#Preview {
    EumHunLearningCardView(learningKanjis: [Dummy.kanji])
        .environmentObject(UserSettings())
}
