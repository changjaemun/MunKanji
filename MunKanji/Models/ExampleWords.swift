//
//  ExampleWords.swift
//  MunKanji
//
//  Created by 문창재 on 9/24/25.
//
import SwiftData

@Model
class KanjiExample {
    @Attribute(.unique) var kanji: String
    var examples: [ExampleData]
    
    init(kanji: String, examples: [ExampleData]) {
        self.kanji = kanji
        self.examples = examples
    }
}

struct ExampleData: Codable {
    let meaning: String
    let word: String
    let sound: String
}
