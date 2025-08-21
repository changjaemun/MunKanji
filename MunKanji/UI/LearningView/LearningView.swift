//
//  SwiftUIView.swift
//  MunKanji
//
//  Created by 문창재 on 6/5/25.
//

import SwiftUI
import SwiftData

struct LearningView: View {
    @State private var currentIndex: Int = 0
    @Binding var path: NavigationPath
    
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @Environment(\.dismiss) private var dismiss
    
    @Query private var kanjis: [Kanji]
    
    let learningStudyLogs: [StudyLog]
    
    private var learningKanjis: [Kanji] {
        var tray: [Kanji] = []
        for log in learningStudyLogs {
            if let kanji = kanjis.first(where: { $0.id == log.kanjiID }) {
                tray.append(kanji)
            }
        }
        return tray
    }
    
    var body: some View {
        VStack {
            Spacer()
            LearningCardScrollView(learningKanjis: learningKanjis, learningStudyLogs: learningStudyLogs)
            Spacer()
            NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                .padding()
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton(action: {dismiss()})
            }
        }
    }
}
