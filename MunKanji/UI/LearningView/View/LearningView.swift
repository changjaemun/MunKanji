//
//  SwiftUIView.swift
//  MunKanji
//
//  Created by 문창재 on 6/5/25.
//

import SwiftUI
import SwiftData

struct LearningView: View {
    @Binding var path: NavigationPath
    
    @EnvironmentObject var userSettings: UserSettings
    
    @ObservedObject var viewModel: LerningViewModel
    
    var body: some View {
        let learningKanjis = viewModel.learningKanjis(mode: userSettings.currentMode, countPerSession: userSettings.kanjiCountPerSession)
        let learningStudyLogs = viewModel.learningStudyLogs(mode: userSettings.currentMode, countPerSession: userSettings.kanjiCountPerSession)
        
        VStack {
            Spacer()
            if userSettings.currentMode == .eumhun {
                EumHunLearningCardView(learningKanjis: learningKanjis)
            } else {
                LearningCardScrollView(learningKanjis: learningKanjis, learningStudyLogs: learningStudyLogs)
                    .frame(height: 340)
            }
            Spacer()
 
            NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                .padding(.bottom, 60)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    
    let sampleKanjis = [
        Kanji(id: 0, grade: "소학교 1학년", kanji: "車", korean: "수레 거, 수레 차", sound: "しゃ", meaning: "くるま", memoryTip: "위에서 내려다본 수레의 바퀴와 축, 그리고 몸체를 본뜬 상형자예요."),
        Kanji(id: 1, grade: "소학교 1학년", kanji: "犬", korean: "개 견", sound: "けん", meaning: "いぬ", memoryTip: "옆으로 서 있는 개의 모습을 본뜬 상형자랍니다."),
        Kanji(id: 2, grade: "소학교 1학년", kanji: "見", korean: "볼 견", sound: "けん", meaning: "みる", memoryTip: "눈(目)과 사람(儿)이 합쳐진 회의자예요.")
    ]
    
    let sampleStudyLogs = [
        Dummy.studyLogUnseen,
        Dummy.studyLogCorrect,
        Dummy.studyLogIncorrect
    ]
    
    NavigationStack {
        LearningView(
            path: $path,
            viewModel: LerningViewModel(
                kanjis: sampleKanjis,
                studyLogs: sampleStudyLogs,
                eumhunStudyLogs: []
            )
        )
        .environmentObject(UserSettings())
    }
}

