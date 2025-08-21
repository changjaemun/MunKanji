//
//  HistoryNavigationLink.swift
//  MunKanji
//
//  Created by 문창재 on 8/21/25.
//

import SwiftUI

struct HistoryNavigationLink: View {
    let count: Int
    let title: String
    let statusFilter: [StudyStatus]
    
    var body: some View {
        NavigationLink{
            HistoryDetailView(title: title, statusFilter: statusFilter)
        }label: {
            ZStack{
                Rectangle()
                    .frame(width: 362, height: 190)
                    .modifier(CardStyle())
                VStack(spacing: 10){
                    Text("\(count)")
                        .foregroundStyle(.main)
                        .font(.pretendardBold(size: 60))
                    Text("외운 한자")
                        .foregroundStyle(.main)
                        .font(.pretendardRegular(size: 20))
                }
            }
        }
    }
}
