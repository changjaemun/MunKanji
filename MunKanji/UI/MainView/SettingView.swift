//
//  SettingView.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var showSheet: Bool
    
    @State private var selectedReviewCycleCount: Int = 2 // 복습 주기는 임시로 유지
    
    let reviewCycleExplain: String = "[맞힌 한자 개수] = [회차당 외울 개수] x [복습 주기]일 때 복습이 진행됩니다."
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            VStack(spacing: 75) {
                VStack {
                    HStack {
                        Text("회차당 외울 한자 개수")
                            .padding()
                        Spacer()
                    }
                    .padding(.top, 45)
                    Picker(selection: $userSettings.kanjiCountPerSession, label: Text("회차당 외울 한자 개수")) {
                        Text("5").tag(5)
                        Text("10").tag(10)
                        Text("20").tag(20)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                VStack {
                    HStack {
                        Text("복습 주기 : 현재 지원하지 않는 기능입니다.")
                            .foregroundStyle(.fontGray)
                            .padding()
                        Spacer()
                    }
                    Picker(selection: $selectedReviewCycleCount, label: Text("복습주기")) {
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }
                    .disabled(true)
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    HStack {
                        Text(reviewCycleExplain)
                            .font(.pretendardRegular(size: 12))
                            .foregroundStyle(.gray)
                            .padding(.horizontal)
                    }
                }
                Spacer()
                NavyButton(title: "설정완료") {
                    showSheet = false
                }
                .padding(.bottom, 64)
            }
        }
    }
}

#Preview {
    SettingView(showSheet: .constant(true))
        .environmentObject(UserSettings())
}
