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
                            Circle()
                                .fill(.main)
                                .frame(width: 12)
                                .padding(.trailing, 10)
                            Text("맞힌 한자")
                                .foregroundStyle(.introFont)
                                .font(.pretendardRegular(size: 24))
                            Spacer()
                            HStack(spacing: 4) {
                                Text("\(correctCount)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardSemiBold(size: 24))
                                Text("개")
                                    .foregroundStyle(.main)
                                    .font(.pretendardLight(size: 24))
                            }
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Circle()
                                .fill(.incorrect)
                                .frame(width: 12)
                                .padding(.trailing, 10)
                            Text("틀린 한자")
                                .foregroundStyle(.introFont)
                                .font(.pretendardRegular(size: 24))
                            Spacer()
                            HStack(spacing: 4) {
                                Text("\(incorrectCount)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardSemiBold(size: 24))
                                Text("개")
                                    .foregroundStyle(.main)
                                    .font(.pretendardLight(size: 24))
                            }
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
    @Previewable @State var path = NavigationPath()
    return ResultView(path: $path, results: [], learningKanjis: [])
}
