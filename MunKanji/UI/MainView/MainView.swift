//
//  ContentView.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI

struct MainView: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("206")
                    .font(.system(size: 130, weight: .semibold))
                    .padding(.vertical, 169)
                NavyNavigationLink(title: "학습하기", destination: StudyIntroView())
                GrayNavigationLink(title: "기록보기", destination: HistoryView())
            }
            .sheet(isPresented: $showSheet, content: {
                SettingView(showSheet: $showSheet)
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
}


#Preview {
    MainView()
}
