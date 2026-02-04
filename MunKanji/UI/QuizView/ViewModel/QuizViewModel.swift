import SwiftUI
import SwiftData

struct QuizResult {
    let kanjiID: Int
    let newStatus: StudyStatus
}

class QuizViewModel: ObservableObject {
    @Published var results: [QuizResult] = []
    @Published var currentIndex: Int = 0
    @Published var isCorrect: StudyStatus = .unseen
    @Published var isFinished: Bool = false
    @Published var choices: [String] = []
    @Published var showResult: Bool = false
    @Published var selectedAnswer: String = "" // 선택된 답안 추적

    var allKanjis: [Kanji] = []
    var learningKanjis: [Kanji] = []
    private var modelContext: ModelContext?
    private var studyMode: StudyMode = .kanji

    init() {
    }

    // 초기화 및 퀴즈 설정
    func setup(learningKanjis: [Kanji], allKanjis: [Kanji], modelContext: ModelContext, studyMode: StudyMode) {
        self.allKanjis = allKanjis
        self.modelContext = modelContext
        self.learningKanjis = learningKanjis
        self.studyMode = studyMode
        // 첫 문제의 보기 생성
        generateChoices()
    }
    
    // 4개 보기 생성 (정답 1개 + 오답 3개)
    func generateChoices() {
        guard currentIndex < learningKanjis.count else { return }
        
        let correctAnswer = learningKanjis[currentIndex].korean
        var wrongAnswers: [String] = []
        
        // 오답 3개 생성
        let otherKanjis = allKanjis.filter { $0.id != learningKanjis[currentIndex].id }
        let shuffledOthers = otherKanjis.shuffled()
        
        for kanji in shuffledOthers {
            if wrongAnswers.count < 3 && kanji.korean != correctAnswer {
                wrongAnswers.append(kanji.korean)
            }
        }
        
        // 정답과 오답을 합쳐서 섞기
        choices = [correctAnswer] + wrongAnswers
        choices.shuffle()
    }
    
    //MARK: --  답안 선택 시 호출
    func selectAnswer(selectedAnswer: String) {
        guard currentIndex < learningKanjis.count else { return }
        self.selectedAnswer = selectedAnswer
        let isCorrect = selectedAnswer == learningKanjis[currentIndex].korean
        let status: StudyStatus = isCorrect ? .correct : .incorrect
        
        // 결과 저장
        let result = QuizResult(kanjiID: learningKanjis[currentIndex].id, newStatus: status)
        results.append(result)
        
        // UI 상태 업데이트
        self.isCorrect = status
        
        // 다음 문제로 이동 또는 퀴즈 완료
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.moveToNextQuestion()
        }
    }
    
    // 다음 문제로 이동
    func moveToNextQuestion() {
        currentIndex += 1
        isCorrect = .unseen
        selectedAnswer = ""
        
        if currentIndex >= learningKanjis.count {
            // 퀴즈 완료
            finishQuiz()
        } else {
            // 다음 문제 보기 생성
            generateChoices()
        }
    }
    
    // 퀴즈 완료 처리
    func finishQuiz() {
        isFinished = true
        saveResultsToSwiftData()
    }
    
    // SwiftData에 결과 저장
    func saveResultsToSwiftData() {
        guard let context = modelContext else { return }
            
            for result in results {
                updateStudyLog(result: result, context: context)
            }
            do {
                try context.save()
                print("✅ Quiz results saved")
            } catch {
                print("❌ Context save error: \(error)")
            }
    }
    
    //MARK: -- result 결과에 따라 StudyLog 또는 EumHunStudyLog를 업데이트 하는 함수
    func updateStudyLog(result: QuizResult, context: ModelContext){
        let idToFind = result.kanjiID

        if studyMode == .eumhun {
            // 음훈 모드: EumHunStudyLog 업데이트
            let descriptor = FetchDescriptor<EumHunStudyLog>(
                predicate: #Predicate { $0.kanjiID == idToFind }
            )
            do {
                let eumhunStudyLogs = try context.fetch(descriptor)
                let eumhunStudyLog = eumhunStudyLogs.first ?? EumHunStudyLog(kanjiID: idToFind)

                eumhunStudyLog.status = result.newStatus

                if result.newStatus == .correct {
                    eumhunStudyLog.reviewCount += 1
                    eumhunStudyLog.lastStudiedDate = Date()
                    if eumhunStudyLog.reviewCount >= 4 {
                        eumhunStudyLog.status = .mastered
                    }
                } else {
                    eumhunStudyLog.lastStudiedDate = nil
                    if eumhunStudyLog.reviewCount > 0 {
                        eumhunStudyLog.reviewCount -= 1
                    }
                }

                print("✅ EumHunStudyLog 업데이트: kanjiID=\(idToFind), status=\(eumhunStudyLog.status)")
            } catch {
                print("❌ EumHunStudyLog 업데이트 실패: \(error)")
            }
        } else {
            // 한자 모드: StudyLog 업데이트
            let descriptor = FetchDescriptor<StudyLog>(
                predicate: #Predicate { $0.kanjiID == idToFind }
            )
            do {
                let studyLogs = try context.fetch(descriptor)
                let studyLog = studyLogs.first ?? StudyLog(kanjiID: idToFind)

                studyLog.status = result.newStatus

                if result.newStatus == .correct {
                    studyLog.reviewCount += 1
                    studyLog.lastStudiedDate = Date()
                    if studyLog.reviewCount >= 4 {
                        studyLog.status = .mastered
                    }
                } else {
                    studyLog.lastStudiedDate = nil
                    if studyLog.reviewCount > 0 {
                        studyLog.reviewCount -= 1
                    }
                }

                print("✅ StudyLog 업데이트: kanjiID=\(idToFind), status=\(studyLog.status)")
            } catch {
                print("❌ StudyLog 업데이트 실패: \(error)")
            }
        }
    }
    
    // 현재 문제의 정답 반환
    var currentCorrectAnswer: String {
        guard currentIndex < learningKanjis.count else { return "" }
        return learningKanjis[currentIndex].korean
    }
    
    // 현재 문제의 한자 반환
    var currentKanji: String {
        guard currentIndex < learningKanjis.count else { return "" }
        return learningKanjis[currentIndex].kanji
    }
    
    // 진행률 계산
    var progress: Double {
        guard !learningKanjis.isEmpty else { return 0 }
        return Double(currentIndex) / Double(learningKanjis.count)
    }
}
