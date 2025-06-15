//
//  Kanji.swift
//  MunKanji
//
//  Created by 문창재 on 6/12/25.
//


import SwiftData
import Foundation


@Model final class Kanji{
    @Attribute(.unique) var id:Int

    var grade: String

    var kanji: String
    var korean: String

    var sound: String
    var meaning: String

    var firstWord: String?
    var secondWord: String?

    init(id: Int, grade: String, kanji: String, korean: String, sound: String, meaning: String, firstWord: String?, secondWord: String?) {
        self.id = id
        self.grade = grade
        self.kanji = kanji
        self.korean = korean
        self.sound = sound
        self.meaning = meaning
        self.firstWord = firstWord
        self.secondWord = secondWord
    }
}

