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
            // Kanji Card Carousel
            TabView(selection: $currentIndex) {
                ForEach(Array(learningKanjis.enumerated()), id: \.element.id) { index, kanji in
                    KanjiWithExampleCardView(kanji: kanji)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 250)
            .padding(.horizontal)

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
        .frame(width: 338, height: 70)
    }
}

#Preview {
    EumHunLearningCardView(learningKanjis: [Dummy.kanji])
        .environmentObject(UserSettings())
}
