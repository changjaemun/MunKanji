//
//  StudyIntroViewModelTests.swift
//  MunKanjiTests
//
//  Created by Claude on 2/5/26.
//

import Testing
import Foundation
@testable import MunKanji

@MainActor
struct StudyIntroViewModelTests {

    // MARK: - 헬퍼

    private func makeStudyLog(
        kanjiID: Int,
        status: StudyStatus,
        reviewCount: Int = 0,
        lastStudiedDate: Date? = nil
    ) -> StudyLog {
        let log = StudyLog(kanjiID: kanjiID)
        log.status = status
        log.reviewCount = reviewCount
        log.lastStudiedDate = lastStudiedDate
        return log
    }

    private func makeEumHunStudyLog(
        kanjiID: Int,
        status: StudyStatus,
        reviewCount: Int = 0,
        lastStudiedDate: Date? = nil
    ) -> EumHunStudyLog {
        let log = EumHunStudyLog(kanjiID: kanjiID)
        log.status = status
        log.reviewCount = reviewCount
        log.lastStudiedDate = lastStudiedDate
        return log
    }

    // MARK: - 전부 mastered → 학습할 한자 없음

    @Test func allKanjiMastered_noLearningKanjis() {
        let logs = (0..<2136).map { id in
            makeStudyLog(
                kanjiID: id,
                status: .mastered,
                reviewCount: 4,
                lastStudiedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
            )
        }

        let vm = StudyIntroViewModel(studyLogs: logs, eumhunStudyLogs: [])

        #expect(vm.isAllMastered(mode: .kanji) == true)
        #expect(vm.hasLearningKanjis(mode: .kanji, countPerSession: 10) == false)
        #expect(vm.totalAvailableCount(mode: .kanji) == 0)
    }

    @Test func allEumhunMastered_noLearningKanjis() {
        let eumhunLogs = (0..<2136).map { id in
            makeEumHunStudyLog(
                kanjiID: id,
                status: .mastered,
                reviewCount: 4,
                lastStudiedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
            )
        }

        let vm = StudyIntroViewModel(studyLogs: [], eumhunStudyLogs: eumhunLogs)

        #expect(vm.isAllMastered(mode: .eumhun) == true)
        #expect(vm.hasLearningKanjis(mode: .eumhun, countPerSession: 10) == false)
        #expect(vm.totalAvailableCount(mode: .eumhun) == 0)
    }

    // MARK: - mastered 한자가 복습에 안 나오는지

    @Test func masteredKanji_doesNotAppearInReview() {
        // mastered 상태, 30일 전에 학습 (nextReviewDate가 확실히 과거)
        let log = makeStudyLog(
            kanjiID: 0,
            status: .mastered,
            reviewCount: 4,
            lastStudiedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())
        )

        let vm = StudyIntroViewModel(studyLogs: [log], eumhunStudyLogs: [])

        let result = vm.kanjiLearningStudyLogs(countPerSession: 10)
        #expect(result.isEmpty)
        #expect(vm.totalAvailableCount(mode: .kanji) == 0)
    }

    // MARK: - 복습 대기 중 (correct이지만 nextReviewDate가 미래)

    @Test func allCorrect_futureReview_noAvailableKanjis() {
        // 방금 맞힘 → reviewCount=1, nextReviewDate = 오늘+1일 = 내일
        let logs = (0..<10).map { id in
            makeStudyLog(
                kanjiID: id,
                status: .correct,
                reviewCount: 1,
                lastStudiedDate: Date()
            )
        }

        let vm = StudyIntroViewModel(studyLogs: logs, eumhunStudyLogs: [])

        #expect(vm.isAllMastered(mode: .kanji) == false)
        #expect(vm.hasLearningKanjis(mode: .kanji, countPerSession: 10) == false)
        #expect(vm.totalAvailableCount(mode: .kanji) == 0)
    }

    // MARK: - 남은 한자가 설정보다 적을 때 (2136 중 6개만 남음)

    @Test func availableCount_lessThanSetting() {
        // 6개만 unseen
        let unseenLogs = (0..<6).map { id in
            makeStudyLog(kanjiID: id, status: .unseen)
        }
        // 나머지 mastered
        let masteredLogs = (6..<20).map { id in
            makeStudyLog(
                kanjiID: id,
                status: .mastered,
                reviewCount: 4,
                lastStudiedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())
            )
        }

        let vm = StudyIntroViewModel(
            studyLogs: unseenLogs + masteredLogs,
            eumhunStudyLogs: []
        )

        #expect(vm.totalAvailableCount(mode: .kanji) == 6)
        #expect(vm.hasLearningKanjis(mode: .kanji, countPerSession: 10) == true)

        // 10개 요청해도 6개만 반환
        let result = vm.kanjiLearningStudyLogs(countPerSession: 10)
        #expect(result.count == 6)
    }

    // MARK: - 틀림 + 복습 + 신규 혼합 카운트

    @Test func mixedStatus_correctCounts() {
        // 틀림 3개
        let incorrectLogs = (0..<3).map { id in
            makeStudyLog(kanjiID: id, status: .incorrect)
        }
        // 복습 대상 2개 (어제 학습, reviewCount=1 → nextReviewDate = 어제+1 = 오늘)
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let reviewLogs = (3..<5).map { id in
            makeStudyLog(
                kanjiID: id,
                status: .correct,
                reviewCount: 1,
                lastStudiedDate: yesterday
            )
        }
        // 신규 5개
        let unseenLogs = (5..<10).map { id in
            makeStudyLog(kanjiID: id, status: .unseen)
        }

        let allLogs = incorrectLogs + reviewLogs + unseenLogs
        let vm = StudyIntroViewModel(studyLogs: allLogs, eumhunStudyLogs: [])

        #expect(vm.totalAvailableCount(mode: .kanji) == 10)
        #expect(vm.inCorrectKanjisCount(mode: .kanji, countPerSession: 10) == 3)
        #expect(vm.reviewKanjisCount(mode: .kanji, countPerSession: 10) == 2)
        #expect(vm.unseenKanjisCount(mode: .kanji, countPerSession: 10) == 5)
    }

    // MARK: - 우선순위 (틀림 > 복습 > 신규)

    @Test func priority_incorrectFirst_thenReview_thenUnseen() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

        // 신규 5개 (id: 0~4)
        let unseenLogs = (0..<5).map { id in
            makeStudyLog(kanjiID: id, status: .unseen)
        }
        // 복습 3개 (id: 5~7)
        let reviewLogs = (5..<8).map { id in
            makeStudyLog(
                kanjiID: id,
                status: .correct,
                reviewCount: 1,
                lastStudiedDate: yesterday
            )
        }
        // 틀림 2개 (id: 8~9)
        let incorrectLogs = (8..<10).map { id in
            makeStudyLog(kanjiID: id, status: .incorrect)
        }

        let allLogs = unseenLogs + reviewLogs + incorrectLogs
        let vm = StudyIntroViewModel(studyLogs: allLogs, eumhunStudyLogs: [])

        // 5개만 요청 → 틀림 2 + 복습 3 = 5 (신규는 안 나옴)
        let result = vm.kanjiLearningStudyLogs(countPerSession: 5)
        #expect(result.count == 5)

        let resultIDs = result.map { $0.kanjiID }
        // 틀림(8,9)이 먼저, 복습(5,6,7)이 그 다음
        #expect(resultIDs == [8, 9, 5, 6, 7])
    }

    // MARK: - 일부만 mastered → isAllMastered == false

    @Test func notAllMastered_whenSomeUnseen() {
        var logs: [StudyLog] = []
        for id in 0..<10 {
            if id < 8 {
                logs.append(makeStudyLog(kanjiID: id, status: .mastered, reviewCount: 4))
            } else {
                logs.append(makeStudyLog(kanjiID: id, status: .unseen))
            }
        }

        let vm = StudyIntroViewModel(studyLogs: logs, eumhunStudyLogs: [])

        #expect(vm.isAllMastered(mode: .kanji) == false)
        #expect(vm.totalAvailableCount(mode: .kanji) == 2)
    }
}
