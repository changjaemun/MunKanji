//
//  ContentView.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI
import SwiftData

enum NavigationTarget: Hashable {
    case studyMain
    case studyIntro
    case learning
    case quiz([StudyLog])
    case history
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .studyMain:
            hasher.combine(0)
        case .studyIntro:
            hasher.combine(1)
        case .learning:
            hasher.combine(2)
        case .quiz(let logs):
            hasher.combine(3)
            hasher.combine(logs.map { $0.id })
        case .history:
            hasher.combine(4)
        }
    }
    
    static func == (lhs: NavigationTarget, rhs: NavigationTarget) -> Bool {
        switch (lhs, rhs) {
        case (.studyMain, .studyMain):
            return true
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
    //@State private var path = NavigationPath()
    @Binding var path: NavigationPath
    
    @Query var kanjis: [Kanji]
    @Query var studyLogs: [StudyLog]
    
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings
    
    
    var body: some View {
        VStack{
            NavigationLink(value: NavigationTarget.history) {
                Text("\(studyLogs.filter{ log in log.status == .correct}.count)")
                    .font(.pretendardBold(size: 130))
                    .foregroundStyle(.main)
                    .padding(.vertical, 169)
            }
            
            NavyNavigationLink(title: "학습하기", value: NavigationTarget.studyIntro)
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
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        MainView(path: $path)
            .modelContainer(for: [Kanji.self, StudyLog.self], inMemory: true)
            .environmentObject(UserCurrentSession())
            .environmentObject(UserSettings())
    }
}
