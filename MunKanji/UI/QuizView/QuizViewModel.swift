
import SwiftUI
import SwiftData

// 퀴즈 진행 중의 임시 결과를 저장하기 위한 간단한 구조체
struct QuizResult {
    let kanjiID: Int
    let newStatus: StudyStatus
}

class QuizViewModel: ObservableObject {
    var results: [QuizResult] = []
    @Published var currentIndex: Int = 0
    @Published var isFinished: Bool = false
    var allKanjis: [Kanji] = []
    var learningKanjis: [Kanji] = []
    private var modelContext: ModelContext?
    @Published var choices: [String] = []
    
    init(){
    }
    
    //채점해서 results에 담는 함수
    
    //버튼 눌렀을 때 채점 결과에 따라 상태 바꾸는 함수
    
    //버튼 눌렀을 때 인덱스 하나 늘리는 함수
    
    //마지막 퀴즈 완료했을 때 results를 swiftData에 업데이트하는 함수
    
    //몇 초 딜레이 주는 함수
    
    //4개 보기 생성하는 함수
    
    //초기화
    func setup(learningKanjis: [Kanji], allKanjis: [Kanji], modelContext: ModelContext) {
            self.allKanjis = allKanjis
            self.modelContext = modelContext
        self.learningKanjis = learningKanjis
            
            // 준비가 끝났으니, 첫 문제의 보기 생성
        }
    
    
}
