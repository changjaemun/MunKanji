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
    @Query private var allKanjiExamples: [KanjiWithExampleWords]

    @EnvironmentObject var userSettings: UserSettings

    @State private var selectedKanji: Kanji?

    private var filteredKanjis: [Kanji] {
        if userSettings.currentMode == .eumhun {
            let correctLogs = allEumHunStudyLogs
                .filter { $0.status == .correct }
                .sorted { ($0.lastStudiedDate ?? .distantPast) > ($1.lastStudiedDate ?? .distantPast) }
            return correctLogs.compactMap { log in
                allKanjis.first { $0.id == log.kanjiID }
            }
        } else {
            let correctLogs = allStudyLogs
                .filter { $0.status == .correct }
                .sorted { ($0.lastStudiedDate ?? .distantPast) > ($1.lastStudiedDate ?? .distantPast) }
            return correctLogs.compactMap { log in
                allKanjis.first { $0.id == log.kanjiID }
            }
        }
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
                    // 음훈모드: 카드 + 예시단어 리스트
                    let examples = allKanjiExamples.first { $0.kanjiID == kanji.id }?.examples ?? []
                    ScrollView {
                        VStack(spacing: 12) {
                            KanjiWithExampleCardView(kanji: kanji)
                                .padding(.top, 24)

                            ForEach(Array(examples.enumerated()), id: \.offset) { _, example in
                                KanjiExampleRowView(example: example)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                } else {
                    // 한자모드: 색띠 없는 카드
                    KanjiCardView(
                        kanji: kanji,
                        studyLog: allStudyLogs.first { $0.kanjiID == kanji.id } ?? StudyLog(kanjiID: kanji.id),
                        showStatusBar: false
                    )
                }
            }
            .presentationDetents([.medium, .large])
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .environmentObject(UserSettings())
    }
}
