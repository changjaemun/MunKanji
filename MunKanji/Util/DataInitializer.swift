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
                let newKanji = Kanji(id: index, grade: word.grade ?? "", kanji: word.kanji ?? "", korean: word.korean ?? "", sound: word.sound ?? "", meaning: word.meaning ?? "")
                modelContext.insert(newKanji)

                // 한자 모드용 StudyLog 생성
                let newStudyLog = StudyLog(kanjiID: index)
                modelContext.insert(newStudyLog)

                // 음훈 모드용 EumHunStudyLog 생성
                let newEumHunStudyLog = EumHunStudyLog(kanjiID: index)
                modelContext.insert(newEumHunStudyLog)
            }


            print("초기 데이터 로딩 완료! (Kanji: \(words.count), StudyLog: \(words.count), EumHunStudyLog: \(words.count))")
            
        } catch {
            fatalError("데이터 로딩 중 오류 발생: \(error)")
        }
    }
    
    static func migrateToNewKanjiDataIfNeeded(modelContext: ModelContext) {
        let currentDataVersion = "kanji_2136_v2_eumhun"
        let savedDataVersion = UserDefaults.standard.string(forKey: "dataVersion")

        // 이미 최신 데이터면 아무것도 안 함
        guard savedDataVersion != currentDataVersion else {
            // EumHunStudyLog가 없으면 생성 (기존 사용자 대응)
            addEumHunStudyLogIfNeeded(modelContext: modelContext)
            return
        }

        do {
            // ⚠️ 사용자 학습 기록 보존: StudyLog와 EumHunStudyLog는 절대 삭제하지 않음!
            // 1. 기존 Kanji만 삭제 (학습 기록은 보존)
            let kanjiDescriptor = FetchDescriptor<Kanji>()
            let allKanjis = try modelContext.fetch(kanjiDescriptor)
            for kanji in allKanjis {
                modelContext.delete(kanji)
            }

            // 2. 새 Kanji 데이터만 저장
            let words: [Word] = Word.allWords
            for (index, word) in words.enumerated() {
                let newKanji = Kanji(id: index, grade: word.grade ?? "", kanji: word.kanji ?? "", korean: word.korean ?? "", sound: word.sound ?? "", meaning: word.meaning ?? "")
                modelContext.insert(newKanji)
            }

            // 3. StudyLog가 없으면 생성 (기존 사용자는 이미 있으므로 건너뜀)
            let studyLogDescriptor = FetchDescriptor<StudyLog>()
            let studyLogCount = try modelContext.fetchCount(studyLogDescriptor)
            if studyLogCount == 0 {
                for (index, _) in words.enumerated() {
                    let newStudyLog = StudyLog(kanjiID: index)
                    modelContext.insert(newStudyLog)
                }
            }

            // 4. EumHunStudyLog가 없으면 생성
            addEumHunStudyLogIfNeeded(modelContext: modelContext)

            // 5. 버전 저장
            UserDefaults.standard.set(currentDataVersion, forKey: "dataVersion")
            print("✅ 데이터 마이그레이션 완료 (학습 기록 보존)")
        } catch {
            print("❌ 데이터 마이그레이션 실패: \(error)")
        }
    }

    // 기존 사용자를 위한 EumHunStudyLog 추가
    static func addEumHunStudyLogIfNeeded(modelContext: ModelContext) {
        do {
            let descriptor = FetchDescriptor<EumHunStudyLog>()
            let count = try modelContext.fetchCount(descriptor)

            guard count == 0 else {
                print("EumHunStudyLog 데이터가 이미 존재합니다.")
                return
            }

            print("기존 사용자용 EumHunStudyLog 생성 중...")

            // Kanji 개수만큼 EumHunStudyLog 생성
            let kanjiDescriptor = FetchDescriptor<Kanji>()
            let kanjis = try modelContext.fetch(kanjiDescriptor)

            for kanji in kanjis {
                let newEumhunLog = EumHunStudyLog(kanjiID: kanji.id)
                modelContext.insert(newEumhunLog)
            }

            try modelContext.save()
            print("✅ EumHunStudyLog \(kanjis.count)개 생성 완료")
        } catch {
            print("❌ EumHunStudyLog 생성 실패: \(error)")
        }
    }
}
