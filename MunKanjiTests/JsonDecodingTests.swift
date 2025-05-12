//
//  JsonDecodingTests.swift
//  MunKanji
//
//  Created by 문창재 on 3/31/25.
//

import Testing
@testable import MunKanji

struct JsonDecodingTests {
    @Test func testDecodingJson() {
        let result = JsonManager.shared.load(fileName: "characters")
        print(result)
        var wordList = JsonManager.shared.getWordsFromData(jsonWordFileData: result!)
        
        guard var wordList = wordList else {
            return
        }
        wordList.sort(by: { $0.grade!.split(separator: " ")[1].first! < $1.grade!.split(separator: " ")[1].first!})
        print(wordList)
        
        JsonManager.shared.saveWordsToJSONFile(words: wordList)
    }
}
