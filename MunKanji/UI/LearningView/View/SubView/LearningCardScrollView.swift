//
//  LearningCardScrollView.swift
//  MunKanji
//
//  Created by 문창재 on 8/19/25.
//

import SwiftUI

struct LearningCardScrollView: View {
    let learningKanjis: [Kanji]
    let learningStudyLogs: [StudyLog]

    private let cardWidth: CGFloat = 338

    var body: some View {
        GeometryReader { geometry in
            let horizontalPadding = (geometry.size.width - cardWidth) / 2

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(learningKanjis, id: \.id) { kanji in
                        KanjiCardView(kanji: kanji, studyLog: learningStudyLogs.filter { $0.kanjiID == kanji.id }.first!)
                            .id(kanji.id)
                    }
                }
                .padding(.vertical, 16)
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .contentMargins(.horizontal, horizontalPadding, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}
