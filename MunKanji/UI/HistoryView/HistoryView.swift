//
//  HistoryView.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {

    @Query private var allKanjis: [Kanji]
    @Query private var allStudyLogs: [StudyLog]
    @Query private var allEumHunStudyLogs: [EumHunStudyLog]

    @EnvironmentObject var userSettings: UserSettings

    @State private var selectedKanji: Kanji?

    private var filteredKanjis: [Kanji] {
        let targetLogIDs: [Int]
        if userSettings.currentMode == .eumhun {
            targetLogIDs = allEumHunStudyLogs.filter { $0.status == .correct }.map { $0.kanjiID }
        } else {
            targetLogIDs = allStudyLogs.filter { $0.status == .correct }.map { $0.kanjiID }
        }
        return allKanjis.filter { targetLogIDs.contains($0.id) }.sorted { $0.id < $1.id }
    }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color.backGround
                .ignoresSafeArea()
            if filteredKanjis.isEmpty {
                VStack(spacing: 12) {
                    Text("아직 기록이 없어요")
                        .font(.pretendardMedium(size: 18))
                        .foregroundStyle(.fontGray)
                    Text("\(userSettings.currentMode.displayName)에서 학습을 시작해보세요")
                        .font(.pretendardRegular(size: 14))
                        .foregroundStyle(.fontGray.opacity(0.7))
                }
            } else {
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
        }
        .navigationTitle("\(userSettings.currentMode.displayName) 기록")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
        .sheet(item: $selectedKanji) { kanji in
            ZStack {
                Color.backGround
                    .ignoresSafeArea()
                if userSettings.currentMode == .eumhun {
                    KanjiWithExampleCardView(kanji: kanji)
                } else {
                    KanjiCardView(kanji: kanji, studyLog: allStudyLogs.first { $0.kanjiID == kanji.id } ?? StudyLog(kanjiID: kanji.id))
                }
            }
            .presentationDetents([.medium])
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .environmentObject(UserSettings())
    }
}
