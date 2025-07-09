import SwiftUI
import SwiftData

// 퀴즈 진행 중의 임시 결과를 저장하기 위한 간단한 구조체
struct QuizResult {
    let kanjiID: Int
    let newStatus: StudyStatus
    let currentSession: Int
}

class QuizViewModel: ObservableObject {
    @Published var results: [QuizResult] = []
    @Published var currentIndex: Int = 0
    @Published var isCorrect: StudyStatus = .unseen
    @Published var isFinished: Bool = false
    @Published var choices: [String] = []
    @Published var showResult: Bool = false
    @Published var selectedAnswer: String = "" // 선택된 답안 추적
    @Published var currentSession: Int = 0
    
    var allKanjis: [Kanji] = []
    var learningKanjis: [Kanji] = []
    private var modelContext: ModelContext?
    
    init() {
    }
    
    // 초기화 및 퀴즈 설정
    func setup(learningKanjis: [Kanji], allKanjis: [Kanji], modelContext: ModelContext) {
        self.allKanjis = allKanjis
        self.modelContext = modelContext
        self.learningKanjis = learningKanjis
        
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
    
    // 답안 선택 시 호출
    func selectAnswer(selectedAnswer: String) {
        self.selectedAnswer = selectedAnswer
        var isCorrect = selectedAnswer == learningKanjis[currentIndex].korean
        let status: StudyStatus = isCorrect ? .correct : .incorrect
        
        // 결과 저장
        let result = QuizResult(kanjiID: learningKanjis[currentIndex].id, newStatus: status, currentSession: currentSession)
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
        guard let modelContext = modelContext else { return }
        
        for result in results {
            let idToFind = result.kanjiID
            // 기존 StudyLog 찾기
            let descriptor = FetchDescriptor<StudyLog>(
                predicate: #Predicate<StudyLog> { $0.kanjiID == idToFind }
            )
            do {
                let existingLogs = try modelContext.fetch(descriptor)
                if let existingLog = existingLogs.first {
                    // 기존 로그 업데이트
                    existingLog.status = result.newStatus
                    existingLog.lastStudiedDate = Date()
                    existingLog.lastStudiedSession = currentSession
                    if result.newStatus == .correct {
                        let reviewSession = calReviewSession(lastStudiedSession: currentSession, reviewCount: existingLog.reviewCount)
                        existingLog.nextReviewSession = reviewSession
                    }
                } else {
                    // 새 로그 생성
                    let newLog = StudyLog(kanjiID: result.kanjiID)
                    newLog.status = result.newStatus
                    newLog.lastStudiedDate = Date()
                    modelContext.insert(newLog)
                    print("주의: 기존 study로그가 없어 새로 생성했습니다.")
                }
            } catch {
                print("Error saving quiz results: \(error)")
            }
        }
        do {
            try modelContext.save()
            print("Quiz results saved successfully")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func calReviewSession(lastStudiedSession:Int ,reviewCount: Int) -> Int{
        var reviewSession:Int{
            switch reviewCount {
            case 0: return lastStudiedSession + 3
            case 1: return lastStudiedSession + 5
            case 2: return lastStudiedSession + 7
            default:
                return 0 //더이상 복습할 필요 없음
            }
        }
        return reviewSession
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
