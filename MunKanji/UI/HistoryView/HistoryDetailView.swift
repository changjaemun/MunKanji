//
//  HistoryDetailView.swift
//  MunKanji
//
//  Created by 문창재 on 6/19/25.
//

import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    let title: String
    let statusFilter: [StudyStatus]
    
    @Query private var allKanjis: [Kanji]
    @Query private var allStudyLogs: [StudyLog]
    
    @State private var selectedKanji: Kanji?
    
    private var filteredKanjis: [Kanji] {
        let targetLogIDs = allStudyLogs.filter { statusFilter.contains($0.status) }.map { $0.kanjiID }
        return allKanjis.filter { targetLogIDs.contains($0.id) }.sorted{$0.id < $1.id}
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack{
            Color.backGround
                .ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(filteredKanjis, id: \.self) { kanji in
                        Button {
                            selectedKanji = kanji
                        } label: {
                            MiniKanjiCardView(kanji: kanji)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        })
        .sheet(item: $selectedKanji) { kanji in
            ZStack{
                Color.backGround
                    .ignoresSafeArea()
                KanjiCardView(kanji: kanji, studyLog: allStudyLogs.first { $0.kanjiID == kanji.id } ?? StudyLog(kanjiID: kanji.id))
            }
        }
    }
}

#Preview {
    HistoryDetailView(title: "외운 한자", statusFilter: [.correct])
}
