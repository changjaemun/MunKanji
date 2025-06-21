//
//  QuizView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    
    @Query
    var kanjis:[Kanji]
    
    let learningStudyLogs: [StudyLog]
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: QuizViewModel = QuizViewModel()
    
    var learningKanjis:[Kanji]{
        var tray:[Kanji] = []
        for log in learningStudyLogs{
            let kanji = kanjis.filter{$0.id == log.kanjiID}.first ?? Dummy.kanji
            tray.append(kanji)
        }
        return tray
    }
    
    @State var currentIndex:Int = 0
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround.ignoresSafeArea()
                if viewModel.learningKanjis.isEmpty {
                    ProgressView()
                        .scaleEffect(2)
                }else{
                    VStack(spacing:64){
                        Text("\(viewModel.currentIndex + 1) / \(learningStudyLogs.count)")
                            .foregroundStyle(.fontGray)
                            .font(.system(size: 24, weight: .semibold))
                        Text(viewModel.learningKanjis[viewModel.currentIndex].kanji)
                                .foregroundStyle(.main)
                                .font(.system(size: 80, weight: .semibold))
                        
                        QuizGridView()
                            .frame(width: 346, height: 340)
                        Spacer()
                    }.padding()
                }
            }.navigationTitle("1회차")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.setup(learningKanjis: learningKanjis, allKanjis: kanjis, modelContext: modelContext)
                }
        }
    }
}

#Preview {
    
    QuizView(learningStudyLogs: Dummy.studylog)
}
