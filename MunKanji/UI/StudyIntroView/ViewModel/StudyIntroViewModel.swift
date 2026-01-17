//
//  StudyIntroViewModel.swift
//  MunKanji
//
//  Created by 문창재 on 8/21/25.
//
import SwiftData
import SwiftUI

class StudyIntroViewModel: ObservableObject {
    var studyLogs: [StudyLog]
    
    init(userSettings: UserSettings, studyLogs: [StudyLog]) {
        self.studyLogs = studyLogs
        self.userSettings = userSettings
    }
    
    var userSettings: UserSettings
    
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
    
    var inCorrectKanjisCount:Int{
        learningStudyLogs.filter{$0.status == .incorrect}.count
    }
    
    var reviewKanjisCount:Int{
    learningStudyLogs.filter{ if $0.nextReviewDate != nil {return true} else {return false}}.count
}
    
    var unseenKanjisCount:Int{
        learningStudyLogs.filter{$0.status == .unseen}.count
    }
    
}
