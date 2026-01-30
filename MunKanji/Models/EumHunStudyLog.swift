//
//  EumHunStudyLog.swift
//  MunKanji
//
//  Created by 문창재 on 1/28/26.
//

import Foundation
import SwiftData

@Model
final class EumHunStudyLog {
    @Attribute(.unique) var kanjiID: Int

    var status: StudyStatus

    var lastStudiedDate: Date?

    var reviewCount: Int = 0

    var nextReviewDate: Date? {
        guard let base = lastStudiedDate else { return nil }

        let daysToAdd: Int
        switch reviewCount {
        case 0: daysToAdd = 0
        case 1: daysToAdd = 1
        case 2: daysToAdd = 3
        case 3: daysToAdd = 7
        default: daysToAdd = 14
        }

        return Calendar.current.date(byAdding: .day, value: daysToAdd, to: base)
    }

    init(kanjiID: Int) {
        self.kanjiID = kanjiID
        self.status = .unseen
    }
}

/*

 📚 EumHunStudyLog 구조 설명

 ## 역할
 - 음훈 모드에서 각 한자의 학습 진행 상황을 추적하는 모델
 - StudyLog(한자 모드)와 완전히 분리되어 독립적으로 관리됨
 - 2136개 한자 각각에 대해 하나씩 생성됨

 ## 주요 필드

 1. kanjiID (Int)
    - 어떤 한자인지 식별하는 ID
    - Kanji 모델의 id와 1:1 매칭
    - @Attribute(.unique): 중복 불가, 한 한자당 하나의 기록만 존재

 2. status (StudyStatus)
    - 현재 학습 상태를 나타냄
    - .unseen: 아직 학습하지 않음 (초기 상태)
    - .incorrect: 퀴즈에서 틀림 (예시 단어 3개 중 1개라도 틀림)
    - .correct: 퀴즈에서 맞힘 (예시 단어 3개 모두 정답)

 3. lastStudiedDate (Date?)
    - 마지막으로 퀴즈를 푼 날짜
    - 복습 일정 계산의 기준이 됨
    - nil: 아직 한 번도 퀴즈를 풀지 않음

 4. reviewCount (Int)
    - 몇 번 맞혔는지 카운트
    - 맞힐 때마다 1씩 증가
    - 틀리면 0으로 리셋
    - 이 값에 따라 다음 복습 간격이 결정됨

 5. nextReviewDate (Date? - 계산 프로퍼티)
    - 다음 복습이 나올 날짜를 자동으로 계산
    - 간격 반복 학습(Spaced Repetition) 알고리즘:
      * 0회: 즉시 (오늘)
      * 1회: 1일 후
      * 2회: 3일 후
      * 3회: 7일 후
      * 4회 이상: 14일 후
    - 시간이 지날수록 복습 간격이 길어짐

 ## 생명주기

 1. 앱 최초 실행
    └─> 2136개의 EumHunStudyLog 생성 (모두 status: .unseen)

 2. 사용자가 음훈 모드 학습 시작
    └─> 학습 대상 선정: .unseen > .incorrect > 복습 대상 순으로

 3. 학습 화면
    └─> 한자의 예시 단어 5개 보여줌 (KanjiExample 사용)

 4. 퀴즈 화면
    └─> 예시 단어 중 랜덤 3개 출제
    └─> 사용자가 발음(sound) 입력

 5. 채점 및 업데이트
    └─> 3개 모두 정답:
        - status = .correct
        - reviewCount += 1
        - lastStudiedDate = 오늘
    └─> 1개라도 오답:
        - status = .incorrect
        - reviewCount = 0
        - lastStudiedDate = 오늘

 6. 복습 시스템
    └─> nextReviewDate가 오늘 이전인 한자들이 복습 대상으로 자동 선정됨

 ## 한자 모드(StudyLog)와의 차이점

 - 한자 모드: 한자의 한글 음훈을 맞히는 퀴즈
 - 음훈 모드: 한자가 포함된 일본어 단어의 발음을 맞히는 퀴즈
 - 각각 독립적인 학습 기록을 유지하므로 한 모드에서 학습해도 다른 모드에 영향 없음

 */
