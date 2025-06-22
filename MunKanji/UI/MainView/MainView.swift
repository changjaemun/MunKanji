//
//  ContentView.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI
import SwiftData

// 내비게이션 타겟을 정의하는 Hashable Enum
enum NavigationTarget: Hashable {
    case studyIntro
    case learning([StudyLog])
    case quiz([StudyLog])
    case history

    // StudyLog 배열을 비교하기 위해 id만 사용하도록 Hashable, Equatable 구현
    func hash(into hasher: inout Hasher) {
        switch self {
        case .studyIntro:
            hasher.combine(0)
        case .learning(let logs):
            hasher.combine(1)
            hasher.combine(logs.map { $0.id })
        case .quiz(let logs):
            hasher.combine(2)
            hasher.combine(logs.map { $0.id })
        case .history:
            hasher.combine(3)
        }
    }

    static func == (lhs: NavigationTarget, rhs: NavigationTarget) -> Bool {
        switch (lhs, rhs) {
        case (.studyIntro, .studyIntro):
            return true
        case (.learning(let lhsLogs), .learning(let rhsLogs)):
            return lhsLogs.map { $0.id } == rhsLogs.map { $0.id }
        case (.quiz(let lhsLogs), .quiz(let rhsLogs)):
            return lhsLogs.map { $0.id } == rhsLogs.map { $0.id }
        case (.history, .history):
            return true
        default:
            return false
        }
    }
}


struct MainView: View {
    @State var showSheet: Bool = false
    @State private var path = NavigationPath()
    
    @Query
    private var allStudyLogs: [StudyLog]
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                Text("\(allStudyLogs.filter{ log in log.status == .correct}.count)")
                    .font(.pretendardBold(size: 130))
                    .padding(.vertical, 169)
                NavyNavigationLink(title: "학습하기", value: NavigationTarget.studyIntro)
                GrayNavigationLink(title: "기록보기", value: NavigationTarget.history)
            }
            .sheet(isPresented: $showSheet, content: {
                SettingView(showSheet: $showSheet)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        showSheet = true
                    }label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.main)
                    }
                }
            }
            .navigationDestination(for: NavigationTarget.self) { target in
                switch target {
                case .studyIntro:
                    StudyIntroView(path: $path)
                case .learning(let logs):
                    LearningView(path: $path, learningStudyLogs: logs)
                case .quiz(let logs):
                    QuizView(path: $path, learningStudyLogs: logs)
                case .history:
                    HistoryView()
                }
            }
        }
    }
}


#Preview {
    MainView()
}
