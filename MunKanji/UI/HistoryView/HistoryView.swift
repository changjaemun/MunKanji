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
    @Environment(\.dismiss) private var dismiss
    
    private var correctCount: Int {
        allStudyLogs.filter { $0.status == .correct }.count
    }
    
    private var incorrectCount: Int {
        allStudyLogs.count - correctCount
    }
    
    var body: some View {
        ZStack{
            Color.backGround.ignoresSafeArea()
            VStack(spacing:55){
                Spacer()
                NavigationLink {
                    HistoryDetailView(title: "외운 한자", statusFilter: [.correct])
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 362, height: 190)
                            .modifier(CardStyle())
                        VStack(spacing: 10){
                            Text("\(correctCount)")
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 60))
                            Text("외운 한자")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 20))
                        }
                    }
                }
                NavigationLink {
                    HistoryDetailView(title: "못외운 한자", statusFilter: [.unseen, .incorrect])
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 362, height: 190)
                            .modifier(CardStyle())
                        VStack(spacing: 10){
                            Text("\(incorrectCount)")
                                .foregroundStyle(.point)
                                .font(.pretendardBold(size: 60))
                            Text("못외운 한자")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 20))
                        }
                    }
                }
                .padding(.bottom, 160)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                backButton(action: {dismiss()})
            }
        })
        .navigationTitle("기록")
    }
}

#Preview {
    HistoryView()
}
