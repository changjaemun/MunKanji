import Foundation
import SwiftData

class DataInitializer {
    
    // 이 함수를 호출하면, 필요할 때만 데이터를 넣습니다.
    static func seedInitialData(modelContext: ModelContext) {
        
        // 1. 먼저 데이터베이스에 Kanji 데이터가 하나라도 있는지 확인
        let descriptor = FetchDescriptor<Kanji>()
        
        // 에러 처리를 위해 do-catch 사용
        do {
            let count = try modelContext.fetchCount(descriptor)
            
            // 2. 만약 count가 0이 아니면 (즉, 데이터가 이미 있으면)
            //    아무것도 하지 않고 함수를 조용히 종료합니다.
            guard count == 0 else {
                print("데이터가 이미 존재하므로 초기 데이터 로딩을 건너뜁니다.")
                return
            }
            
            // 3. count가 0일 때만 (즉, DB가 비어있을 때만) 아래 로직 실행
            print("초기 데이터를 로딩합니다...")
            
            // JSON 디코딩
            let words: [Word] = Word.allWords
            // 변환 및 저장
            for (index, word) in words.enumerated(){
                let newKanji = Kanji(id: index, grade: word.grade ?? "", kanji: word.kanji ?? "", korean: word.korean ?? "", sound: word.sound ?? "", meaning: word.meaning ?? "", firstWord: word.firstWord, secondWord: word.secondWord)
                modelContext.insert(newKanji)
                
                //newKanji와 짝이 될 StudyLog 객체 생성 및 저장
                let newStudyLog = StudyLog(kanjiID: index)
                modelContext.insert(newStudyLog)
            }
            
            
            print("초기 데이터 로딩 완료!")
            
        } catch {
            fatalError("데이터 로딩 중 오류 발생: \(error)")
        }
    }
}
