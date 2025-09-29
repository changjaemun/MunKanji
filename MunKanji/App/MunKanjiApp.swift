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
            SelectModeView()
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
