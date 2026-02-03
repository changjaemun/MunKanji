//
//  Dummy.swift
//  MunKanji
//
//  Created by 문창재 on 6/21/25.
//

import Foundation

struct Dummy {
    static let kanji: Kanji = Kanji(id: 0, grade: "초등학교 1학년", kanji: "車", korean: "수레 차", sound: "しゃ", meaning: "くるま")

    static let kanjiWithTip: Kanji = Kanji(
        id: 1,
        grade: "초등학교 1학년",
        kanji: "車",
        korean: "수레 차",
        sound: "しゃ",
        meaning: "くるま",
        memoryTip: "수레바퀴의 모양을 본뜬 상형자예요. 가운데 축과 양쪽 바퀴가 보이시나요?"
    )

    static let studylog: [StudyLog] = [StudyLog(kanjiID: 0), StudyLog(kanjiID: 1), StudyLog(kanjiID: 2), StudyLog(kanjiID: 3), StudyLog(kanjiID: 4), StudyLog(kanjiID: 5), StudyLog(kanjiID: 6), StudyLog(kanjiID: 7), StudyLog(kanjiID: 8), StudyLog(kanjiID: 9)]

    static var studyLogUnseen: StudyLog {
        let log = StudyLog(kanjiID: 0)
        log.status = .unseen
        return log
    }

    static var studyLogCorrect: StudyLog {
        let log = StudyLog(kanjiID: 0)
        log.status = .correct
        log.lastStudiedDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
        return log
    }

    static var studyLogIncorrect: StudyLog {
        let log = StudyLog(kanjiID: 0)
        log.status = .incorrect
        return log
    }
}
