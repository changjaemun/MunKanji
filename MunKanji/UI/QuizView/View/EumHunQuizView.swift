//
//  EumHunQuizView.swift
//  MunKanji
//
//  Created by 문창재 on 2/5/26.
//

import SwiftUI
import SwiftData

struct EumHunQuizView: View {
    @Query var kanjis: [Kanji]
    @Query var kanjiExamples: [KanjiWithExampleWords]

    @Binding var path: NavigationPath
    let learningStudyLogs: [StudyLog]

    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userSettings: UserSettings
    @StateObject private var viewModel = EumHunQuizViewModel()

    var learningKanjis: [Kanji] {
        var tray: [Kanji] = []
        for log in learningStudyLogs {
            if let kanji = kanjis.first(where: { $0.id == log.kanjiID }) {
                tray.append(kanji)
            }
        }
        return tray
    }

    var body: some View {
        ZStack {
            if learningKanjis.isEmpty {
                ProgressView()
                    .scaleEffect(2)
            } else if viewModel.isFinished {
                ResultView(
                    path: $path,
                    results: viewModel.aggregatedResults,
                    learningKanjis: learningKanjis
                )
            } else {
                VStack(spacing: 48) {
                    // 진행도
                    Text("\(viewModel.currentIndex + 1) / \(viewModel.questions.count)")
                        .foregroundStyle(.fontGray)
                        .font(.pretendardSemiBold(size: 24))

                    // 예시단어 (출제 문제)
                    Text(viewModel.currentWord)
                        .foregroundStyle(.fontBlack)
                        .font(.pretendardSemiBold(size: 56))
                        .minimumScaleFactor(0.6)
                        .lineLimit(1)

                    // 4지선다
                    EumHunQuizGridView(viewModel: viewModel)
                        .frame(width: 346, height: 340)

                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            if !viewModel.isFinished {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
            }
        }
        .onAppear {
            viewModel.setup(
                learningKanjis: learningKanjis,
                allKanjiExamples: kanjiExamples,
                modelContext: modelContext
            )
        }
    }
}
