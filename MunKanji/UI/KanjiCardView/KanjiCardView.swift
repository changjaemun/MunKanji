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
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                      .frame(width: 338, height: 521)
                      .cornerRadius(20)
                      .shadow(radius: 20)
                    VStack(alignment:.leading){
                        VStack{
                            Text(word.kanji!)
                                .foregroundStyle(.main)
                                .font(.system(size: 80, weight: .bold))
                            Text(word.korean!)
                                .foregroundStyle(.main)
                                .font(.system(size: 24))
                        }.frame(width: 338)
                            .padding(.bottom)
                        Divider()
                            .frame(width: 330)
                        VStack(alignment:.leading){
                            Text("음: \(word.sound!)")
                                .foregroundStyle(.main)
                                .font(.system(size: 24))
                                .padding(10)
                            Text("훈: \(word.meaning!)")
                                .foregroundStyle(.main)
                                .font(.system(size: 24))
                                .padding(10)
                        }.padding()
                        
                        
                        Divider()
                            .frame(width: 330)
                        VStack(alignment:.leading){
                            Text(word.firstWord!)
                                .foregroundStyle(.main)
                                .font(.system(size: 24))
                                .padding(10)
                            Text(word.secondWord!)
                                .foregroundStyle(.main)
                                .font(.system(size: 24))
                                .padding(10)
                        }.padding()
                        
                    }.frame(width: 338, height: 521)
                    
                }
        }
    }


#Preview {
    KanjiCardView()
}
