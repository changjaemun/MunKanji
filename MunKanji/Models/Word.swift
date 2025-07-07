//
//  Untitled.swift
//  MunKanji
//
//  Created by 문창재 on 3/31/25.
//
import Foundation

struct Word: Codable {
    
    var grade: String?
    var kanji: String?
    var korean: String?
    var sound: String?
    var meaning: String?
    
    enum CodingKeys: String, CodingKey {
        case grade, kanji, korean, sound, meaning
    }
    
    static var allWords:[Word] = {
        guard let load = JsonManager.shared.load(fileName: "kanji_2136") else{
            print("load error")
            return []
        }
        guard let words = JsonManager.shared.getWordsFromData(jsonWordFileData: load) else{
            print("decode error")
            return []
        }
        return words
    }()
}


