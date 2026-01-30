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

    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings

    @ObservedObject var viewModel: LerningViewModel

    var body: some View {
        let learningKanjis = viewModel.learningKanjis(mode: userSettings.currentMode, countPerSession: userSettings.kanjiCountPerSession)
        let learningStudyLogs = viewModel.learningStudyLogs(mode: userSettings.currentMode, countPerSession: userSettings.kanjiCountPerSession)

        return VStack {
            Spacer()
            if userSettings.currentMode == .eumhun {
                EumHunLearningCardView(learningKanjis: learningKanjis)
            } else {
                LearningCardScrollView(learningKanjis: learningKanjis, learningStudyLogs: learningStudyLogs)
            }
            Spacer()
            NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                .padding()
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}
