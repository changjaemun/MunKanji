//
//  HistoryView.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query private var allStudyLogs: [StudyLog]
    
    private var correctCount: Int {
        allStudyLogs.filter { $0.status == .correct }.count
    }
    
    private var incorrectCount: Int {
        allStudyLogs.count - correctCount
    }
    
    var body: some View {
        VStack(spacing:55){
            Spacer()
            HistoryNavigationLink(count: correctCount, title: "외운 한자", statusFilter: [.correct])
            HistoryNavigationLink(count: incorrectCount, title: "못외운 한자", statusFilter: [.unseen, .incorrect])
                .padding(.bottom, 160)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backGround.ignoresSafeArea())
            .navigationBarBackButtonHidden()
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
            })
            .navigationTitle("기록")
    }
}

#Preview {
    HistoryView()
}
