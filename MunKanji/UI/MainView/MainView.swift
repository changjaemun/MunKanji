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
    case learning
    case quiz([StudyLog])
    case history

    // StudyLog 배열을 비교하기 위해 id만 사용하도록 Hashable, Equatable 구현
    func hash(into hasher: inout Hasher) {
        switch self {
        case .studyIntro:
            hasher.combine(0)
        case .learning:
            hasher.combine(1)
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
        case (.learning, .learning):
            return true
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
    
    @Query var kanjis: [Kanji]
    @Query var studyLogs: [StudyLog]
    
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings
    
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                Text("\(studyLogs.filter{ log in log.status == .correct}.count)")
                    .font(.pretendardBold(size: 130))
                    .foregroundStyle(.main)
                    .padding(.vertical, 169)
                NavyNavigationLink(title: "학습하기", value: NavigationTarget.studyIntro)
                GrayNavigationLink(title: "기록보기", value: NavigationTarget.history)
            }
            .sheet(isPresented: $showSheet, content: {
                SettingView(showSheet: $showSheet)
                    .presentationDetents([.fraction(0.6)])
                    .presentationDragIndicator(.visible)
                    .presentationCornerRadius(35)
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
                    StudyIntroView(viewModel: StudyIntroViewModel(userSettings: userSettings, studyLogs: studyLogs), path: $path)
                case .learning:
                    LearningView(path: $path, viewModel: LerningViewModel(kanjis: kanjis, studyLogs: studyLogs, userSettings: userSettings))
                case .quiz(let logs):
                    QuizView(path: $path, learningStudyLogs: logs)
                case .history:
                    HistoryView()
                }
            }
        }
    }
}
