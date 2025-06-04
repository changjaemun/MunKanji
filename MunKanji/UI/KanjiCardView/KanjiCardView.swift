//
//  KanjiCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/4/25.
//

import SwiftUI

struct KanjiCardView: View {
    let word:Word = Word(firstWord: "電車[でんしゃ] 전철", secondWord: "車[くるま] 차, 자동차", kanji: "車",korean: "수레 차", sound: "しゃ", meaning: "くるま")
    
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    KanjiCardView()
}
