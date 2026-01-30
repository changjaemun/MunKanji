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
            // Page Indicator
            PageIndicatorView(totalPages: learningKanjis.count, currentPage: currentIndex)
                .padding(.bottom, 16)

            // Kanji Card Carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(learningKanjis.enumerated()), id: \.element.id) { index, kanji in
                    KanjiWithExampleCardView(kanji: kanji)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 230)
            .padding(.horizontal)

            // Example Words List
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(Array(currentExamples.enumerated()), id: \.offset) { _, example in
                        KanjiExampleRowView(example: example)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Page Indicator
struct PageIndicatorView: View {
    let totalPages: Int
    let currentPage: Int
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? userSettings.currentMode.primaryColor : Color.gray.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

// MARK: - Updated KanjiExampleRowView with ExampleData
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
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white)
                )
            HStack {
                Spacer()
                Text(word)
                    .font(.pretendardRegular(size: 28))
                    .foregroundStyle(.fontBlack)
                Spacer()
                Divider()
                    .padding(.vertical)
                VStack(alignment: .leading, spacing: 9) {
                    Text(sound)
                        .font(.pretendardMedium(size: 20))
                        .foregroundStyle(.fontBlack)
                    Text(meaning)
                        .font(.pretendardLight(size: 12))
                        .foregroundStyle(.introFont)
                }
                .padding(.leading, 4)
                Spacer()
            }
        }
        .frame(width: 298, height: 70)
        .padding(4)
    }
}

#Preview {
    EumHunLearningCardView(learningKanjis: [Dummy.kanji])
        .environmentObject(UserSettings())
}
