//
//  ContentView.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @State var showSheet: Bool = false
    
    @Query
    private var allStudyLogs: [StudyLog]
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("\(allStudyLogs.filter{ log in log.status == .correct}.count)")
                    .font(.pretendardBold(size: 130))
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
