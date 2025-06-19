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
              .shadow(radius: 5)
            Text(word)
                .font(.system(size: 40))
        }
        
    }
}
