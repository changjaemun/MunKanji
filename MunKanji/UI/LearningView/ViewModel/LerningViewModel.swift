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
    var userSettings: UserSettings
    
    
    init(kanjis: [Kanji], studyLogs: [StudyLog], userSettings: UserSettings) {
        self.kanjis = kanjis
        self.studyLogs = studyLogs
        self.userSettings = userSettings
    }
    
    var learningKanjis:[Kanji] {
        var tray: [Kanji] = []
        for log in learningStudyLogs {
            if let kanji = kanjis.first(where: { $0.id == log.kanjiID }) {
                tray.append(kanji)
            }
        }
        return tray
    }
    
    var learningStudyLogs:[StudyLog]{
    
    let incorrectStudyLogs: [StudyLog] = {
        return studyLogs
            .filter { $0.status == .incorrect }
            .sorted { $0.kanjiID < $1.kanjiID }
    }()
    
    let reviewStudyLogs: [StudyLog] = {
        return studyLogs
            .filter {
                if let nextReviewDate = $0.nextReviewDate {
                    return nextReviewDate <= Date()
                }
                return false
            }
            .sorted { $0.kanjiID < $1.kanjiID }
    }()
    
    let unseenStudyLogs: [StudyLog] = {
        return studyLogs
            .filter { $0.status == .unseen}
            .sorted { $0.kanjiID < $1.kanjiID }
    }()
    
    let tray = Array(incorrectStudyLogs + reviewStudyLogs + unseenStudyLogs).prefix(userSettings.kanjiCountPerSession)
    
    return Array(tray)
}
}
