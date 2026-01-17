//
//  MunKanjiApp.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI
import SwiftData

@main
struct MunKanjiApp: App {
    @StateObject private var userSettings = UserSettings()
    @StateObject private var userCurrentSession = UserCurrentSession()
    @State private var path = NavigationPath()

    let container: ModelContainer
    
    init() {
        
        UIView.appearance().overrideUserInterfaceStyle = .light
        
        do {
            let schema = Schema([
                Kanji.self,
                StudyLog.self
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
                .environmentObject(userCurrentSession)
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

    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        NavigationStack(path: $path) {
            MainView(path: $path)
                .navigationDestination(for: NavigationTarget.self) { target in
                    switch target {
                    case .studyMain:
                        MainView(path: $path)
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
