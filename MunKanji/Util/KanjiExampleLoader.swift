//
//  KanjiExampleLoader.swift
//  MunKanji
//
//  Created by 문창재 on 9/24/25.
//

import Foundation
import SwiftData

class KanjiExampleLoader {
    static let shared = KanjiExampleLoader()
    
    private init() {}
    
    func loadKanjiExamplesIfNeeded(modelContext: ModelContext) {
        print("=== KanjiExampleLoader 시작 ===")
        
        // 이미 데이터가 있는지 확인
        let descriptor = FetchDescriptor<KanjiExample>()
        let existingData = try? modelContext.fetch(descriptor)
        
        print("기존 데이터 개수: \(existingData?.count ?? 0)")
        
        if existingData?.isEmpty == false {
            print("KanjiExample 데이터가 이미 존재합니다.")
            return
        }
        
        // JSON 파일 로드
        print("JSON 파일 로드 시도...")
        guard let url = Bundle.main.url(forResource: "Kanji_Examples", withExtension: "json") else {
            print("❌ JSON 파일을 찾을 수 없습니다: Kanji_Examples.json")
            return
        }
        print("✅ JSON 파일 경로: \(url.path)")
        
        guard let data = try? Data(contentsOf: url) else {
            print("❌ JSON 파일 데이터를 읽을 수 없습니다.")
            return
        }
        print("✅ JSON 파일 크기: \(data.count) bytes")
        
        guard let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            print("❌ JSON 파싱 실패")
            return
        }
        print("✅ JSON 파싱 성공, 항목 개수: \(jsonData.count)")
        
        // JSON 데이터를 SwiftData 모델로 변환
        var processedCount = 0
        for (key, value) in jsonData {
            guard let kanjiData = value as? [String: Any],
                  let kanji = kanjiData["kanji"] as? String,
                  let examplesArray = kanjiData["examples"] as? [[String: Any]] else {
                print("⚠️ 키 \(key) 파싱 실패")
                continue
            }
            
            print("처리 중: \(kanji) (키: \(key))")
            
            // ExampleData 배열 생성
            let examples = examplesArray.compactMap { exampleDict -> ExampleData? in
                guard let meaning = exampleDict["meaning"] as? String,
                      let word = exampleDict["word"] as? String,
                      let sound = exampleDict["sound"] as? String else {
                    return nil
                }
                return ExampleData(meaning: meaning, word: word, sound: sound)
            }
            
            // SwiftData 모델 생성 및 저장
            let kanjiExample = KanjiExample(kanji: kanji, examples: examples)
            modelContext.insert(kanjiExample)
            processedCount += 1
            
            if processedCount <= 3 { // 처음 3개만 상세 출력
                print("  - 예시 개수: \(examples.count)")
                for (index, example) in examples.enumerated() {
                    print("    \(index + 1). \(example.word) (\(example.meaning))")
                }
            }
        }
        
        print("총 \(processedCount)개 항목 처리 완료")
        
        // 변경사항 저장
        do {
            try modelContext.save()
            print("KanjiExample 데이터가 성공적으로 로드되었습니다.")
            
            // 저장된 데이터의 첫 번째 항목 프린트
            let descriptor = FetchDescriptor<KanjiExample>()
            let savedData = try modelContext.fetch(descriptor)
            
            if let firstKanjiExample = savedData.first {
                print("=== 첫 번째 KanjiExample ===")
                print("한자: \(firstKanjiExample.kanji)")
                print("예시 개수: \(firstKanjiExample.examples.count)")
                
                // 모든 예시 프린트
                for (index, example) in firstKanjiExample.examples.enumerated() {
                    print("예시 \(index + 1):")
                    print("  - 단어: \(example.word)")
                    print("  - 의미: \(example.meaning)")
                    print("  - 발음: \(example.sound)")
                }
                print("=========================")
            }
        } catch {
            print("데이터 저장 중 오류 발생: \(error)")
        }
    }
}
