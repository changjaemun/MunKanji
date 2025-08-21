//
//  QuizView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    
    @Query var kanjis:[Kanji]
    
    @Binding var path: NavigationPath
    let learningStudyLogs: [StudyLog]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @StateObject private var viewModel: QuizViewModel = QuizViewModel()
    
    var learningKanjis:[Kanji]{
        var tray:[Kanji] = []
        for log in learningStudyLogs{
            let kanji = kanjis.filter{$0.id == log.kanjiID}.first ?? Dummy.kanji
            tray.append(kanji)
        }
        return tray
    }
    
    var body: some View {
        ZStack{
            if learningKanjis.isEmpty {
                ProgressView()
                    .scaleEffect(2)
            } else if viewModel.isFinished {
                ResultView(path: $path, results: viewModel.results, learningKanjis: learningKanjis)
            } else {
                VStack(spacing: 64){
                    Text("\(viewModel.currentIndex + 1) / \(viewModel.learningKanjis.count)")
                        .foregroundStyle(.fontGray)
                        .font(.pretendardSemiBold(size: 24))
                    Text(viewModel.currentKanji)
                        .foregroundStyle(.main)
                        .font(.pretendardSemiBold(size: 80))
                    QuizGridView(viewModel: viewModel)
                        .frame(width: 346, height: 340)
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            if !viewModel.isFinished {
                ToolbarItem(placement: .topBarLeading) {
                    backButton(action: {dismiss()})
                }
            }
        })
        .onAppear {
            viewModel.setup(learningKanjis: learningKanjis, allKanjis: kanjis, modelContext: modelContext, currentSession: userCurrentSession.currentSessionNumber)
        }
    }
}
