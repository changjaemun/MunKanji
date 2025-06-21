//
//  QuizView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI

struct QuizView: View {
    let words:[Word] = Word.allWords
    @State var currentIndex:Int = 0
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround.ignoresSafeArea()
                VStack(spacing:64){
                    Text("\(currentIndex + 1) / \(words.count)")
                        .foregroundStyle(.fontGray)
                        .font(.pretendardSemiBold(size: 24))
                    if let kanji = words[currentIndex].kanji{
                        Text(kanji)
                            .foregroundStyle(.main)
                            .font(.pretendardSemiBold(size: 80))
                    }
                    
                    QuizGridView()
                        .frame(width: 346, height: 340)
                    Spacer()
                }.padding()
            }.navigationTitle("1회차")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    QuizView()
}
