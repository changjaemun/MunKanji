//
//  MunKanjiApp.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI
import SwiftData
import UIKit

// MARK: - Navigation Bar 숨김 상태에서 Swipe Back Gesture 활성화
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

@main
struct MunKanjiApp: App {
    @StateObject private var userSettings = UserSettings()
    @State private var path = NavigationPath()

    let container: ModelContainer
    
    init() {
        
        UIView.appearance().overrideUserInterfaceStyle = .light
        
        do {
            let schema = Schema([
                Kanji.self,
                StudyLog.self,
                EumHunStudyLog.self,
                KanjiWithExampleWords.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            container = try ModelContainer(for: schema, configurations: [modelConfiguration])

        } catch {
            fatalError("모델 컨테이너 생성 실패: \(error)")
        }
    }
    
    var body: some Scene {

        WindowGroup {
            ContentView(path: $path)
                .environmentObject(userSettings)
                .onAppear {
                    DataInitializer.migrateToNewKanjiDataIfNeeded(modelContext: container.mainContext)
                    DataInitializer.seedInitialData(modelContext: container.mainContext)
                    KanjiExampleLoader.shared.loadKanjiExamplesIfNeeded(
                        modelContext: container.mainContext
                    )
                }
        }.modelContainer(container)
    }
}

struct ContentView: View {
    @Binding var path: NavigationPath
    @Query var kanjis: [Kanji]
    @Query var studyLogs: [StudyLog]
    @Query var eumhunStudyLogs: [EumHunStudyLog]

    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        NavigationStack(path: $path) {
            MainView(path: $path)
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .studyMain:
                        MainView(path: $path)
                    case .studyIntro:
                        StudyIntroView(viewModel: StudyIntroViewModel(studyLogs: studyLogs, eumhunStudyLogs: eumhunStudyLogs), path: $path)
                    case .learning:
                        LearningView(path: $path, viewModel: LerningViewModel(kanjis: kanjis, studyLogs: studyLogs, eumhunStudyLogs: eumhunStudyLogs))
                    case .quiz(let logs):
                        QuizView(path: $path, learningStudyLogs: logs)
                    case .history:
                        HistoryView()
                    }
                }
        }
    }
}
