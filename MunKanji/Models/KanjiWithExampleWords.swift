//
//  KanjiWithExampleWords.swift
//  MunKanji
//
//  Created by 문창재 on 9/24/25.
//
import SwiftData

@Model
class KanjiWithExampleWords {
    @Attribute(.unique) var kanjiID: Int
    var kanji: String
    var examples: [ExampleData]

    init(kanjiID: Int, kanji: String, examples: [ExampleData]) {
        self.kanjiID = kanjiID
        self.kanji = kanji
        self.examples = examples
    }
}

struct ExampleData: Codable {
    let meaning: String
    let word: String
    let sound: String
}

/*

 📚 KanjiWithExampleWords 구조 설명

 ## 역할
 - 각 한자의 일본어 예시 단어들을 저장하는 모델
 - 음훈 모드 학습에 사용됨

 ## 주요 필드

 1. kanjiID (Int)
    - Kanji 모델의 id와 1:1 매칭되는 ID
    - JSON 파일의 키값 ("0", "1", ...)을 Int로 변환한 값
    - @Attribute(.unique): 중복 불가, 한 한자당 하나의 레코드만 존재

 2. kanji (String)
    - 한자 문자 (예: "車", "犬")
    - 화면에 표시할 때 사용

 3. examples ([ExampleData])
    - 해당 한자가 들어간 일본어 단어 예시들
    - 보통 5개 정도의 예시가 포함됨
    - 음훈 모드 학습 화면에서 5개 모두 표시
    - 퀴즈에서는 이 중 랜덤 3개 출제

 ## ExampleData 구조

 - meaning: 한글 뜻 (예: "차륜")
 - word: 일본어 단어 (예: "車輪")
 - sound: 읽는 법/발음 (예: "しゃりん")

 ## 데이터 흐름

 1. Kanji_Examples.json 파일 읽기
    {
      "0": {
        "kanji": "車",
        "examples": [
          { "word": "車輪", "sound": "しゃりん", "meaning": "차륜" },
          ...
        ]
      }
    }

 2. KanjiExampleLoader가 JSON 파싱
    - 키 "0" → kanjiID: 0
    - "kanji": "車" → kanji: "車"
    - "examples" → examples 배열

 3. SwiftData에 저장
    - 2136개의 KanjiWithExampleWords 레코드 생성

 4. 사용 예시
    let example = kanjiWithExampleWords.first { $0.kanjiID == 0 }
    // example.kanji = "車"
    // example.examples = [車輪, 車庫, 電車, ...]

 */
