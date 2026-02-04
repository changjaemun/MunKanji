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
    @Binding var path: NavigationPath

    @Query var kanjis: [Kanji]
    @Query var studyLogs: [StudyLog]
    @Query var eumhunStudyLogs: [EumHunStudyLog]

    @EnvironmentObject var userSettings: UserSettings

    var correctCount: Int {
        if userSettings.currentMode == .eumhun {
            return eumhunStudyLogs.filter { $0.status == .correct || $0.status == .mastered }.count
        } else {
            return studyLogs.filter { $0.status == .correct || $0.status == .mastered }.count
        }
    }

    private let totalKanjis = 2136

    private var progress: Double {
        guard totalKanjis > 0 else { return 0 }
        return Double(correctCount) / Double(totalKanjis)
    }

    @State private var animatedProgress: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            // 모드선택 버튼: 오른쪽 상단
            HStack {
                Spacer()
                ModeSelectButton()
            }
            .padding(.trailing, 20)
            .padding(.top, 8)

            Spacer()

            NavigationLink(value: NavigationTarget.history) {
                ZStack {
                    // 배경 트랙
                    Circle()
                        .stroke(
                            userSettings.currentMode.primaryColor.opacity(0.12),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )

                    // 진행 링
                    Circle()
                        .trim(from: 0, to: animatedProgress)
                        .stroke(
                            userSettings.currentMode.primaryColor,
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    // 중앙 텍스트
                    VStack(spacing: 4) {
                        Text("\(correctCount)")
                            .font(.pretendardBold(size: 72))
                            .foregroundStyle(userSettings.currentMode.primaryColor)
                            .contentTransition(.numericText())
                        Text("/ \(totalKanjis)")
                            .font(.pretendardRegular(size: 18))
                            .foregroundStyle(.fontGray)
                    }
                }
                .frame(width: 240, height: 240)
            }

            Spacer()

            // 학습하기 버튼: 홈인디케이터로부터 60 떨어지게
            NavyNavigationLink(title: "학습하기", value: NavigationTarget.studyIntro)
                .font(.pretendardSemiBold(size: 24))
                .containerRelativeFrame(.horizontal) { width, _ in
                    min(width * 0.75, 320)  // 화면의 75%, 최대 320pt
                }
                .frame(height: 68)
                .padding(.bottom, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            // 처음 등장 시 0에서 시작하여 애니메이션
            animatedProgress = 0
            withAnimation(.easeOut(duration: 1.0)) {
                animatedProgress = progress
            }
        }
        .onChange(of: correctCount) { _, _ in
            // 퀴즈 끝나고 돌아왔을 때 업데이트 애니메이션
            withAnimation(.easeOut(duration: 0.6)) {
                animatedProgress = progress
            }
        }
    }
}

struct ModeSelectButton: View {
    @State private var showModeMenu: Bool = false
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                showModeMenu.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Text(userSettings.currentMode.displayName)
                    .font(.pretendardSemiBold(size: 20))
                    .foregroundStyle(.white)
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(showModeMenu ? 180 : 0))
            }
            .frame(width: 110, height: 45)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(userSettings.currentMode.primaryColor)
            )
        }
        .popover(isPresented: $showModeMenu, arrowEdge: .top) {
            ModeSelectionView(showModeMenu: $showModeMenu)
        }
    }
}

struct ModeSelectionView: View {
    @Binding var showModeMenu: Bool
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(StudyMode.allCases, id: \.self) { mode in
                Button {
                    userSettings.currentMode = mode
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showModeMenu = false
                    }
                } label: {
                    HStack {
                        Text(mode.displayName)
                            .font(.pretendardRegular(size: 17))
                            .foregroundStyle(.primary)
                        Spacer()
                        if userSettings.currentMode == mode {
                            Image(systemName: "checkmark")
                                .foregroundStyle(mode.primaryColor)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if mode != StudyMode.allCases.last {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 0.5)
                        .padding(.horizontal)
                }
            }
        }
        .frame(width: 200)
        .presentationCompactAdaptation(.popover)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        MainView(path: $path)
            .modelContainer(for: [Kanji.self, StudyLog.self, EumHunStudyLog.self], inMemory: true)
            .environmentObject(UserSettings())
    }
}
