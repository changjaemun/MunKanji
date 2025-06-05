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
}
