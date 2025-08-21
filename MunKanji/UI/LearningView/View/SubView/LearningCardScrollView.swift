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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer().frame(width: 20)
                ForEach(learningKanjis, id: \.id) { kanji in
                    KanjiCardView(kanji: kanji, studyLog: learningStudyLogs.filter{$0.kanjiID == kanji.id}.first!)
                        .id(kanji.id)
                }
                Spacer().frame(width: 20)
            }
            .padding()
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}
