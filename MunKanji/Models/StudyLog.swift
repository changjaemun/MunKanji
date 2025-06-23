//
//  StudyLog.swift
//  MunKanji
//
//  Created by 문창재 on 6/19/25.
//
import Foundation
import SwiftData

// 학습 상태를 명확하게 관리하기 위한 Enum
enum StudyStatus: String, Codable {
    case unseen   // 아직 학습하지 않음
    case incorrect // 틀림
    case correct   // 맞힘
}

@Model
final class StudyLog {
    // 이 ID는 Kanji의 id와 1:1로 매칭됩니다.
    // 어떤 한자에 대한 기록인지 알려주는 "꼬리표" 역할을 합니다.
    @Attribute(.unique) var kanjiID: Int
    
    // 현재 학습 상태 (unseen, incorrect, correct)
    var status: StudyStatus
    
    // 마지막으로 퀴즈를 푼 날짜
    var lastStudiedDate: Date?
    
    init(kanjiID: Int) {
        self.kanjiID = kanjiID
        self.status = .unseen // 모든 학습 기록은 "안 본 상태"에서 시작
    }
}
