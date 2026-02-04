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
                Spacer()
                NavyButton(title: "설정완료") {
                    showSheet = false
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    SettingView(showSheet: .constant(true))
        .environmentObject(UserSettings())
}
