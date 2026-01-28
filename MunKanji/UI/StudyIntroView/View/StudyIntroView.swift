//
//  StudyIntroView.swift
//  MunKanji
//
//  Created by 문창재 on 5/28/25.
//

import SwiftUI
import SwiftData

struct StudyIntroView: View {
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var viewModel: StudyIntroViewModel

    @Binding var path: NavigationPath

    var body: some View {
        VStack{
            Spacer()
            StudyInfoCountInfoView(inCorrectKanjisCount: viewModel.inCorrectKanjisCount, reviewKanjisCount: viewModel.reviewKanjisCount, unseenKanjisCount: viewModel.unseenKanjisCount)

            Spacer()

            // 외울 개수 Stepper
            KanjiCountStepper()
                .padding(.bottom, 20)

            NavyNavigationLink(title: "학습시작", value: NavigationTarget.learning)
                .padding(.bottom, 40)
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

struct KanjiCountStepper: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        HStack(spacing: 16) {
            Button {
                if userSettings.kanjiCountPerSession > 5 {
                    userSettings.kanjiCountPerSession -= 5
                }
            } label: {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(userSettings.kanjiCountPerSession > 5 ? userSettings.currentMode.primaryColor : .gray)
            }
            .disabled(userSettings.kanjiCountPerSession <= 5)

            VStack(spacing: 2) {
                Text("\(userSettings.kanjiCountPerSession)")
                    .font(.pretendardBold(size: 32))
                    .foregroundStyle(userSettings.currentMode.primaryColor)
                Text("개 학습")
                    .font(.pretendardRegular(size: 14))
                    .foregroundStyle(.gray)
            }
            .frame(width: 80)

            Button {
                if userSettings.kanjiCountPerSession < 50 {
                    userSettings.kanjiCountPerSession += 5
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(userSettings.kanjiCountPerSession < 50 ? userSettings.currentMode.primaryColor : .gray)
            }
            .disabled(userSettings.kanjiCountPerSession >= 50)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}
