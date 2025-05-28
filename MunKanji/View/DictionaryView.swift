//
//  Untitled.swift
//  MunKanji
//
//  Created by 문창재 on 3/31/25.
//
import SwiftUI

struct DictionaryView:View {
    var body: some View{
        NavigationStack{
            ScrollView{
                KanjiCellView()
                KanjiCellView()
                KanjiCellView()
            }.navigationTitle("전체보기")
        }
    }
}

#Preview(){
    DictionaryView()
}
