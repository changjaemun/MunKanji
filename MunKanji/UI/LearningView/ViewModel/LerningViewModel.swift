//
//  LerningViewModel.swift
//  MunKanji
//
//  Created by 문창재 on 8/21/25.
//

import SwiftUI

class LerningViewModel: ObservableObject {
    @Published var currentIndex:Int = 0

    var kanjis:[Kanji]
    var studyLogs:[StudyLog]
    var eumhunStudyLogs:[EumHunStudyLog]


    init(kanjis: [Kanji], studyLogs: [StudyLog], eumhunStudyLogs: [EumHunStudyLog]) {
        self.kanjis = kanjis
        self.studyLogs = studyLogs
        self.eumhunStudyLogs = eumhunStudyLogs
    }

    func learningKanjis(mode: StudyMode, countPerSession: Int) -> [Kanji] {
        var tray: [Kanji] = []
        let logs = learningStudyLogs(mode: mode, countPerSession: countPerSession)

        for log in logs {
            if let kanji = kanjis.first(where: { $0.id == log.kanjiID }) {
                tray.append(kanji)
            }
        }
        return tray
    }

    func learningStudyLogs(mode: StudyMode, countPerSession: Int) -> [StudyLog] {
        if mode == .eumhun {
            // 음훈 모드: EumHunStudyLog 사용
            let incorrectLogs = eumhunStudyLogs.filter { $0.status == .incorrect }.sorted { $0.kanjiID < $1.kanjiID }
            let reviewLogs = eumhunStudyLogs.filter {
                guard $0.status != .mastered else { return false }
                if let nextReviewDate = $0.nextReviewDate {
                    return nextReviewDate <= Date()
                }
                return false
            }.sorted { $0.kanjiID < $1.kanjiID }
            let unseenLogs = eumhunStudyLogs.filter { $0.status == .unseen }.sorted { $0.kanjiID < $1.kanjiID }

            let combined = incorrectLogs + reviewLogs + unseenLogs
            let limited = Array(combined.prefix(countPerSession))

            return limited.compactMap { eumhunLog in
                studyLogs.first(where: { $0.kanjiID == eumhunLog.kanjiID })
            }
        } else {
            // 한자 모드: StudyLog 사용
            let incorrectLogs = studyLogs.filter { $0.status == .incorrect }.sorted { $0.kanjiID < $1.kanjiID }
            let reviewLogs = studyLogs.filter {
                guard $0.status != .mastered else { return false }
                if let nextReviewDate = $0.nextReviewDate {
                    return nextReviewDate <= Date()
                }
                return false
            }.sorted { $0.kanjiID < $1.kanjiID }
            let unseenLogs = studyLogs.filter { $0.status == .unseen }.sorted { $0.kanjiID < $1.kanjiID }

            let combined = incorrectLogs + reviewLogs + unseenLogs
            return Array(combined.prefix(countPerSession))
        }
    }

    // 기존 코드 호환성을 위한 계산 프로퍼티 (한자 모드 기본)
    var learningKanjis:[Kanji] {
        learningKanjis(mode: .kanji, countPerSession: 10)
    }

    var learningStudyLogs:[StudyLog] {
        learningStudyLogs(mode: .kanji, countPerSession: 10)
    }
}
