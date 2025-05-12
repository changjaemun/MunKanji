//
//  JsonDecoder.swift
//  MunKanji
//
//  Created by 문창재 on 3/31/25.
//

import Foundation

class JsonManager {
    static var shared: JsonManager = JsonManager() // 싱글톤 패턴
    
    private init() { }
    
    func load(fileName: String) -> Data? {
        let fileNm: String = fileName
        let extensionType = "json"
        
        guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
    
    func getWordsFromData(jsonWordFileData: Data) -> [Word]? {
        let wordList = try? JSONDecoder().decode([Word].self, from: jsonWordFileData)
        return wordList
    }
    
    // MARK: 반환값 -> 성공 여부
    func saveWordsToJSONFile(words: [Word]) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // 가독성을 위해 예쁘게 출력
        
        do {
            let jsonData = try encoder.encode(words)
            
            // 저장할 파일 경로 설정
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent("newwords.json")
            
            // JSON 데이터를 파일에 쓰기
            try jsonData.write(to: fileURL)
            print("✅ JSON 파일 저장 완료: \(fileURL)")
        } catch {
            print("❌ JSON 파일 저장 실패: \(error)")
        }
    }
}


