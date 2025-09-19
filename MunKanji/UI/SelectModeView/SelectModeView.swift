//
//  SelectModeView.swift
//  MunKanji
//
//  Created by 문창재 on 9/16/25.
//

import SwiftUI

struct SelectModeView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 12){
                
                Button{
                    //
                }label: {
                    ModeCardView(mode: "한자 모드", description: "한자의 모양과 음, 뜻을 한글로 학습합니다.", correctCount: 1026, totalCount: 2136)
                }
                
                Button{
                    //
                }label: {
                    ModeCardView(mode: "음훈 모드", description: "한자의 모양과 음, 뜻을 한글로 학습합니다.", correctCount: 1026, totalCount: 2136)
                }
                Spacer()
                Button{
                    
                }label: {
                    HistoryModeCardView()
                }
                Spacer()
            }.padding(.top, 35)
            .navigationTitle("학습하기")
        }
    }
}

struct ModeCardView: View {
    let mode: String
    let description: String
    var backgroundKanji: String {
        if mode == "한자 모드"{
            return "漢字"
        }else{
            return "音訓"
        }
    }
    let correctCount: Int
    let totalCount: Int
    var cardColor: Color{
        if mode == "한자 모드"{
            return .main
        }else{
            return .eumHunMode
        }
    }
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(cardColor)
              .overlay {
                          LinearGradient(
                              colors: [.black, .white],
                              startPoint: .bottom,
                              endPoint: .top
                          ).opacity(0.2)
              }
              .cornerRadius(20)
            VStack{
                HStack{
                    Spacer()
                    Text(backgroundKanji)
                        .font(.pretendardExtraBold(size: 96))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, cardColor],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                            ).opacity(0.2))
                }
                Spacer()
            }
            .padding(.trailing, 12)
            .padding(.top, 12)
            VStack(alignment:.leading, spacing: 5){
                HStack{
                    Text(mode)
                        .font(.pretendardExtraBold(size: 32))
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack{
                    Text(description)
                        .font(.pretendardRegular(size: 11))
                        .foregroundStyle(.white)
                    
                }
                Spacer()
                HStack{
                    Spacer()
                    Text("\(correctCount) / \(totalCount)")
                        .font(.pretendardExtraLight(size: 8))
                        .foregroundStyle(.white)
                }
                ProgressView(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/)
                    .tint(.white)
                Spacer()
            }.padding(.horizontal, 32)
                .padding(.top, 35)
            
            HStack{
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }.padding(.trailing, 12)
            
        }.frame(width: 363, height: 190)
    }
}

struct HistoryModeCardView: View {
    let mode: String = "기록 보기"
    let description: String = "학습 기록을 확인합니다."
    let backgroundKanji: String = "기록"
    let cardColor: Color = .fontGray
    var body: some View{
        ZStack{
            Rectangle()
                .foregroundColor(cardColor)
              .overlay {
                          LinearGradient(
                              colors: [.black, .white],
                              startPoint: .bottom,
                              endPoint: .top
                          ).opacity(0.2)
              }
              .cornerRadius(20)
            VStack{
                HStack{
                    Spacer()
                    Text(backgroundKanji)
                        .font(.pretendardExtraBold(size: 76))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, cardColor],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                            ).opacity(0.2))
                }
                Spacer()
            }
            .padding(.trailing, 12)
            .padding(.top, 12)
            VStack(alignment:.leading, spacing: 5){
                HStack{
                    Text(mode)
                        .font(.pretendardExtraBold(size: 32))
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack{
                    Text(description)
                        .font(.pretendardRegular(size: 11))
                        .foregroundStyle(.white)
                    
                }
            }.padding(.horizontal, 32)
            
            HStack{
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
            }.padding(.trailing, 12)
            
        }.frame(width: 363, height: 126)
    }
}

#Preview {
    SelectModeView()
}
