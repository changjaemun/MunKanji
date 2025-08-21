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
    @ObservedObject var viewModel: StudyIntroViewModel
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack{
            Spacer()
            StudyInfoCountInfoView(inCorrectKanjisCount: viewModel.inCorrectKanjisCount, reviewKanjisCount: viewModel.reviewKanjisCount, unseenKanjisCount: viewModel.unseenKanjisCount)
            Spacer()
            NavyNavigationLink(title: "학습시작", value: NavigationTarget.learning)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}
