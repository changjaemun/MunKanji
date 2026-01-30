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
    var eumhunStudyLogs: [EumHunStudyLog]

    init(studyLogs: [StudyLog], eumhunStudyLogs: [EumHunStudyLog]) {
        self.studyLogs = studyLogs
        self.eumhunStudyLogs = eumhunStudyLogs
    }

    // 한자 모드용
    func kanjiLearningStudyLogs(countPerSession: Int) -> [StudyLog] {
        let incorrectLogs = studyLogs.filter { $0.status == .incorrect }.sorted { $0.kanjiID < $1.kanjiID }
        let reviewLogs = studyLogs.filter {
            if let nextReviewDate = $0.nextReviewDate {
                return nextReviewDate <= Date()
            }
            return false
        }.sorted { $0.kanjiID < $1.kanjiID }
        let unseenLogs = studyLogs.filter { $0.status == .unseen }.sorted { $0.kanjiID < $1.kanjiID }

        let combined = incorrectLogs + reviewLogs + unseenLogs
        return Array(combined.prefix(countPerSession))
    }

    // 음훈 모드용
    func eumhunLearningStudyLogs(countPerSession: Int) -> [EumHunStudyLog] {
        let incorrectLogs = eumhunStudyLogs.filter { $0.status == .incorrect }.sorted { $0.kanjiID < $1.kanjiID }
        let reviewLogs = eumhunStudyLogs.filter {
            if let nextReviewDate = $0.nextReviewDate {
                return nextReviewDate <= Date()
            }
            return false
        }.sorted { $0.kanjiID < $1.kanjiID }
        let unseenLogs = eumhunStudyLogs.filter { $0.status == .unseen }.sorted { $0.kanjiID < $1.kanjiID }

        let combined = incorrectLogs + reviewLogs + unseenLogs
        return Array(combined.prefix(countPerSession))
    }

    // 뷰에서 사용 (한자 모드 기준으로 반환)
    func learningStudyLogs(mode: StudyMode, countPerSession: Int) -> [StudyLog] {
        if mode == .eumhun {
            let eumhunLogs = eumhunLearningStudyLogs(countPerSession: countPerSession)
            return eumhunLogs.compactMap { eumhunLog in
                studyLogs.first(where: { $0.kanjiID == eumhunLog.kanjiID })
            }
        } else {
            return kanjiLearningStudyLogs(countPerSession: countPerSession)
        }
    }

    func inCorrectKanjisCount(mode: StudyMode, countPerSession: Int) -> Int {
        if mode == .eumhun {
            return eumhunLearningStudyLogs(countPerSession: countPerSession).filter { $0.status == .incorrect }.count
        } else {
            return kanjiLearningStudyLogs(countPerSession: countPerSession).filter { $0.status == .incorrect }.count
        }
    }

    func reviewKanjisCount(mode: StudyMode, countPerSession: Int) -> Int {
        if mode == .eumhun {
            return eumhunLearningStudyLogs(countPerSession: countPerSession).filter {
                if let nextReviewDate = $0.nextReviewDate {
                    return nextReviewDate <= Date()
                }
                return false
            }.count
        } else {
            return kanjiLearningStudyLogs(countPerSession: countPerSession).filter {
                if let nextReviewDate = $0.nextReviewDate {
                    return nextReviewDate <= Date()
                }
                return false
            }.count
        }
    }

    func unseenKanjisCount(mode: StudyMode, countPerSession: Int) -> Int {
        if mode == .eumhun {
            return eumhunLearningStudyLogs(countPerSession: countPerSession).filter { $0.status == .unseen }.count
        } else {
            return kanjiLearningStudyLogs(countPerSession: countPerSession).filter { $0.status == .unseen }.count
        }
    }
}
