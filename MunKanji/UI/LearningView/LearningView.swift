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
    
    @Query
    private var kanjis: [Kanji]
    
    let learningStudyLogs: [StudyLog]
    
    // learningStudyLogs를 기반으로 실제 Kanji 객체 배열을 만듭니다.
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
        ZStack{
            Color.backGround
                .ignoresSafeArea()
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer().frame(width: 20)
                        ForEach(learningKanjis, id: \.id) { kanji in
                            KanjiCardView(kanji: kanji)
                                .id(kanji.id)
                        }
                        Spacer().frame(width: 20)
                    }
                    .padding()
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
                Spacer()
                NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                    .padding()
                    .padding(.bottom, 20)
            }
            .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton(action: {dismiss()})
                }
            }
        }
        
    }
}
