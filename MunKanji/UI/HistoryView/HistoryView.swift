//
//  HistoryView.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround.ignoresSafeArea()
                VStack(spacing:55){
                    Spacer()
                    NavigationLink {
                        HistoryDetailView(title: "외운 한자")
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                              .frame(width: 362, height: 190)
                              .cornerRadius(20)
                              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            VStack(spacing: 10){
                                Text("206")
                                    .foregroundStyle(.main)
                                    .font(.pretendardBold(size: 60))
                                Text("외운 한자")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 20))
                            }
                        }
                    }
                    NavigationLink {
                        HistoryDetailView(title: "못외운 한자")
                    } label: {
                        ZStack{
                            Rectangle()
                                .foregroundColor(.white)
                              .frame(width: 362, height: 190)
                              .cornerRadius(20)
                              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                            VStack(spacing: 10){
                                Text("820")
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
            
            .navigationTitle("기록")
        }
    }
}

#Preview {
    HistoryView()
}
