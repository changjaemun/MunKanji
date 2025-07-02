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

    // 2. 앱 전체에서 사용할 '데이터 도서관'(ModelContainer)을 보관할 변수를 만듭니다.
    let container: ModelContainer
    
    // 3. 앱이 시작될 때 '데이터 도서관'을 설정하는 초기화 코드를 작성합니다.
    init() {
        
        UIView.appearance().overrideUserInterfaceStyle = .light //라이트모드 고정
        
        do {
            // 우리 앱이 관리할 데이터 모델들의 목록(Schema)을 정의합니다.
            let schema = Schema([
                Kanji.self,
                StudyLog.self
            ])
            
            // 데이터베이스 설정 (예: 어디에 저장할지 등)
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            // 위 설정대로 '데이터 도서관' 건물을 짓습니다.
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
        } catch {
            // 만약 '데이터 도서관'을 짓다가 문제가 생기면 앱을 중단시키고 에러를 출력합니다.
            fatalError("모델 컨테이너 생성 실패: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(userSettings)
                .onAppear {
                    DataInitializer.seedInitialData(modelContext: container.mainContext)
                }
        }.modelContainer(container)
    }
}

#Preview(body: {
    MainView()
})
