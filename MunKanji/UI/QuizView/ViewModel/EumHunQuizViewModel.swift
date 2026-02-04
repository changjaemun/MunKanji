//
//  EumHunQuizViewModel.swift
//  MunKanji
//
//  Created by 문창재 on 2/5/26.
//

import SwiftUI
import SwiftData

// MARK: - 음훈 퀴즈 문제 데이터
struct EumHunQuizQuestion {
    let kanjiID: Int
    let word: String
    let correctSound: String
    let correctMeaning: String
}

// MARK: - 음훈 퀴즈 선택지
struct EumHunChoice: Hashable {
    let sound: String
    let meaning: String
}

// MARK: - 음훈 퀴즈 ViewModel
class EumHunQuizViewModel: ObservableObject {
    @Published var questions: [EumHunQuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var choices: [EumHunChoice] = []
    @Published var selectedAnswer: EumHunChoice? = nil
    @Published var isCorrect: StudyStatus = .unseen
    @Published var isFinished: Bool = false

    // 한자별 문제 결과 추적: kanjiID → [정답여부]
    private var kanjiResults: [Int: [Bool]] = [:]
    // ResultView 전달용 집계 결과
    var aggregatedResults: [QuizResult] = []

    private var allExamples: [KanjiWithExampleWords] = []
    private var modelContext: ModelContext?

    // 전체 예시 풀 (오답 생성용)
    private var allExamplePool: [ExampleData] = []

    init() {}

    // MARK: - 퀴즈 초기화
    func setup(
        learningKanjis: [Kanji],
        allKanjiExamples: [KanjiWithExampleWords],
        modelContext: ModelContext
    ) {
        self.allExamples = allKanjiExamples
        self.modelContext = modelContext

        // 전체 예시 풀 구성 (오답 생성용)
        allExamplePool = allKanjiExamples.flatMap { $0.examples }

        // 한자별로 문제 생성
        var generatedQuestions: [EumHunQuizQuestion] = []

        for kanji in learningKanjis {
            guard let kanjiExample = allKanjiExamples.first(where: { $0.kanjiID == kanji.id }) else {
                continue
            }

            let examples = kanjiExample.examples
            if examples.isEmpty { continue }

            // min(3, 예시개수) 랜덤 선택
            let count = min(3, examples.count)
            let selected = Array(examples.shuffled().prefix(count))

            for example in selected {
                let question = EumHunQuizQuestion(
                    kanjiID: kanji.id,
                    word: example.word,
                    correctSound: example.sound,
                    correctMeaning: example.meaning
                )
                generatedQuestions.append(question)
            }

            // kanjiResults 초기화
            kanjiResults[kanji.id] = []
        }

        self.questions = generatedQuestions

        if !questions.isEmpty {
            generateChoices()
        }
    }

    // MARK: - 4지선다 생성
    func generateChoices() {
        guard currentIndex < questions.count else { return }

        let current = questions[currentIndex]
        let correctChoice = EumHunChoice(
            sound: current.correctSound,
            meaning: current.correctMeaning
        )

        // 오답 후보: 전체 예시 풀에서 정답과 다른 것들
        var wrongChoices: [EumHunChoice] = []
        let shuffledPool = allExamplePool.shuffled()

        for example in shuffledPool {
            let candidate = EumHunChoice(sound: example.sound, meaning: example.meaning)
            if candidate != correctChoice && !wrongChoices.contains(candidate) {
                wrongChoices.append(candidate)
            }
            if wrongChoices.count >= 3 { break }
        }

        choices = [correctChoice] + wrongChoices
        choices.shuffle()
    }

    // MARK: - 정답 선택
    func selectAnswer(choice: EumHunChoice) {
        guard currentIndex < questions.count else { return }
        selectedAnswer = choice

        let current = questions[currentIndex]
        let correctChoice = EumHunChoice(
            sound: current.correctSound,
            meaning: current.correctMeaning
        )
        let correct = (choice == correctChoice)

        // 결과 기록
        kanjiResults[current.kanjiID, default: []].append(correct)

        // UI 상태
        isCorrect = correct ? .correct : .incorrect

        // 다음 문제로
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.moveToNextQuestion()
        }
    }

    // MARK: - 다음 문제
    func moveToNextQuestion() {
        currentIndex += 1
        isCorrect = .unseen
        selectedAnswer = nil

        if currentIndex >= questions.count {
            finishQuiz()
        } else {
            generateChoices()
        }
    }

    // MARK: - 퀴즈 완료
    func finishQuiz() {
        // 한자별 결과 집계
        aggregatedResults = kanjiResults.map { kanjiID, results in
            let allCorrect = results.allSatisfy { $0 }
            return QuizResult(kanjiID: kanjiID, newStatus: allCorrect ? .correct : .incorrect)
        }

        isFinished = true
        saveResultsToSwiftData()
    }

    // MARK: - SwiftData 저장
    func saveResultsToSwiftData() {
        guard let context = modelContext else { return }

        for result in aggregatedResults {
            updateEumHunStudyLog(result: result, context: context)
        }

        do {
            try context.save()
            print("✅ EumHun quiz results saved")
        } catch {
            print("❌ EumHun context save error: \(error)")
        }
    }

    private func updateEumHunStudyLog(result: QuizResult, context: ModelContext) {
        let idToFind = result.kanjiID

        let descriptor = FetchDescriptor<EumHunStudyLog>(
            predicate: #Predicate { $0.kanjiID == idToFind }
        )

        do {
            let logs = try context.fetch(descriptor)
            let log = logs.first ?? EumHunStudyLog(kanjiID: idToFind)

            log.status = result.newStatus

            if result.newStatus == .correct {
                log.reviewCount += 1
                log.lastStudiedDate = Date()
                if log.reviewCount >= 4 {
                    log.status = .mastered
                }
            } else {
                log.lastStudiedDate = nil
                if log.reviewCount > 0 {
                    log.reviewCount -= 1
                }
            }

            print("✅ EumHunStudyLog 업데이트: kanjiID=\(idToFind), status=\(log.status)")
        } catch {
            print("❌ EumHunStudyLog 업데이트 실패: \(error)")
        }
    }

    // MARK: - 현재 문제 정보
    var currentWord: String {
        guard currentIndex < questions.count else { return "" }
        return questions[currentIndex].word
    }

    var currentMeaning: String {
        guard currentIndex < questions.count else { return "" }
        return questions[currentIndex].correctMeaning
    }

    var currentCorrectAnswer: EumHunChoice {
        guard currentIndex < questions.count else {
            return EumHunChoice(sound: "", meaning: "")
        }
        let q = questions[currentIndex]
        return EumHunChoice(sound: q.correctSound, meaning: q.correctMeaning)
    }

    // ResultView에 전달할 학습 한자 목록
    var learningKanjiIDs: [Int] {
        Array(Set(questions.map { $0.kanjiID })).sorted()
    }

    var progress: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(currentIndex) / Double(questions.count)
    }
}
