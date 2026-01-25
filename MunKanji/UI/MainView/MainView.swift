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
    @Binding var path: NavigationPath
    
    @Query var kanjis: [Kanji]
    @Query var studyLogs: [StudyLog]
    
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings
    
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ModeSelectButton()
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.main)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            Spacer()
            
            NavigationLink(value: NavigationTarget.history) {
                Text("\(studyLogs.filter{ log in log.status == .correct}.count)")
                    .font(.pretendardBold(size: 130))
                    .foregroundStyle(.main)
            }
            
            Spacer()
            NavyNavigationLink(title: "학습하기", value: NavigationTarget.studyIntro)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showSheet, content: {
            SettingView(showSheet: $showSheet)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(35)
        })
    }
}

struct ModeSelectButton: View {
    @State private var showModeMenu: Bool = false
    @State private var selectedMode: String = "한자모드"
    
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showModeMenu.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Text(selectedMode)
                    .font(.pretendardBold(size: 22))
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(showModeMenu ? 180 : 0))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedMode == "한자모드" ? Color.main : Color.eumHunMode)
            )
        }
        .popover(isPresented: $showModeMenu, arrowEdge: .top) {
            ModeSelectionView(selectedMode: $selectedMode, showModeMenu: $showModeMenu)
        }
    }
}

struct ModeSelectionView: View {
    @Binding var selectedMode: String
    @Binding var showModeMenu: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                selectedMode = "한자모드"
                withAnimation(.easeInOut(duration: 0.2)) {
                    showModeMenu = false
                }
            } label: {
                HStack {
                    Text("한자모드")
                        .font(.pretendardRegular(size: 17))
                        .foregroundStyle(.primary)
                    Spacer()
                    if selectedMode == "한자모드" {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 0.5)
                .padding(.horizontal)
            
            Button {
                selectedMode = "음훈모드"
                withAnimation(.easeInOut(duration: 0.2)) {
                    showModeMenu = false
                }
            } label: {
                HStack {
                    Text("음훈모드")
                        .font(.pretendardRegular(size: 17))
                        .foregroundStyle(.primary)
                    Spacer()
                    if selectedMode == "음훈모드" {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .frame(width: 200)
        .presentationCompactAdaptation(.popover)
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
