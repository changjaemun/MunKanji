//
//  ResultView.swift
//  MunKanji
//
//  Created by 문창재 on 6/16/25.
//

import SwiftUI

struct ResultView: View {
    @Binding var path: NavigationPath
    
    let results: [QuizResult]
    let learningKanjis: [Kanji]
    
    private var correctCount: Int {
        results.filter { $0.newStatus == .correct }.count
    }
    
    private var incorrectCount: Int {
        results.filter { $0.newStatus == .incorrect }.count
    }
    
    var body: some View {
        ZStack{
            Color.backGround.ignoresSafeArea()
            VStack{
                Text("학습결과")
                    .foregroundStyle(.main)
                    .font(.pretendardBold(size: 28))
                    .padding(.top, 116)
                
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                      .frame(width: 331, height: 211)
                      .cornerRadius(20)
                      .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    VStack(spacing: 20){
                        HStack{
                            Spacer()
                            Text("맞힌 한자")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 28))
                            Spacer()
                            Text("\(correctCount)개")
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 28))
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("틀린 한자")
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 28))
                            Spacer()
                            Text("\(incorrectCount)개")
                                .foregroundStyle(.red)
                                .font(.pretendardBold(size: 28))
                            Spacer()
                        }
                    }
                }
                .padding(.top, 72)
                
                Spacer()
                NavyButton(title: "완료") {
                    // MainView로 돌아가기
                    path = NavigationPath()
                }
                .padding(.bottom, 84)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    return ResultView(path: $path, results: [], learningKanjis: [])
}
