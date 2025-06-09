//
//  Untitled.swift
//  MunKanji
//
//  Created by 문창재 on 3/31/25.
//
import Foundation

struct Word: Codable {
    
    var grade: String?
    var firstWord: String?
    var secondWord: String?
    var kanji: String?
    var korean: String?
    var sound: String?
    var meaning: String?
    
    enum CodingKeys: String, CodingKey {
        case grade, kanji, korean, sound, meaning
        case firstWord = "word1"
        case secondWord = "word2"
    }
    
    
    static let samples: [Word] = [
            Word(grade: "1", firstWord: "차표", secondWord: "주차", kanji: "車", korean: "수레 차", sound: "しゃ", meaning: "탈것, 자동차"),
            Word(grade: "1", firstWord: "화산", secondWord: "불꽃", kanji: "火", korean: "불 화", sound: "か", meaning: "불"),
            Word(grade: "1", firstWord: "수영", secondWord: "수도", kanji: "水", korean: "물 수", sound: "すい", meaning: "물")
        ]
}


