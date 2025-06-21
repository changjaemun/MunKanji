//
//  MiniKanjiCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/19/25.
//

import SwiftUI

struct MiniKanjiCardView: View {
    let word: String
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
              .frame(width: 105, height: 97)
              .cornerRadius(20)
              .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            Text(word)
                .font(.pretendardRegular(size: 40))
        }
        
    }
}
