//
//  HistoryDetailView.swift
//  MunKanji
//
//  Created by 문창재 on 6/19/25.
//

import SwiftUI

struct HistoryDetailView: View {
    let title: String
    let kanjis = ["車", "犬", "見", "ㄱ", "ㄴ", "ㄷ", "ㄴ"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationStack{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(kanjis, id: \.self) { kanji in
                        Button{
                            isPresented = true
                        }label: {
                            MiniKanjiCardView(word: kanji)
                        }.buttonStyle(.plain)
                        
                    }
                }.padding()
            }.navigationTitle(title)
                .sheet(isPresented: $isPresented) {
                    //KanjiCardView()
                }
        }
    }
}

#Preview {
    HistoryDetailView(title: "외운 한자")
}
