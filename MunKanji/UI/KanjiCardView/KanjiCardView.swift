//
//  KanjiCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/4/25.
//

import SwiftUI

struct KanjiCardView: View {
//    let word:Word = Word(firstWord: "電車[でんしゃ] 전철", secondWord: "車[くるま] 차, 자동차", kanji: "車",korean: "수레 차", sound: "しゃ", meaning: "くるま")
    
    let kanji: Kanji
    
    var body: some View {
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                      .frame(width: 338, height: 521)
                      .cornerRadius(20)
                      .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    VStack(alignment:.leading){
                        VStack{
                            Text(kanji.kanji)
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 80))
                            Text(kanji.korean)
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                        }.frame(width: 338)
                            .padding(.bottom)
                        Divider()
                            .frame(width: 330)
                        VStack(alignment:.leading){
                            Text("음: \(kanji.sound)")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                                .padding(10)
                            Text("훈: \(kanji.meaning)")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                                .padding(10)
                        }.padding()
                        
                        
                        Divider()
                            .frame(width: 330)
                        VStack(alignment:.leading){
                            Text(kanji.firstWord ?? "")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                                .padding(10)
                            Text(kanji.secondWord ?? "")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                                .padding(10)
                        }.padding()
                        
                    }.frame(width: 338, height: 521)
                    
                }
        }
    }
