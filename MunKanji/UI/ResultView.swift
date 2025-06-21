//
//  ResultView.swift
//  MunKanji
//
//  Created by 문창재 on 6/16/25.
//

import SwiftUI

struct ResultView: View {
    var body: some View {
        NavigationStack{
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
                          .frame(width: 331, height: 185)
                          .cornerRadius(20)
                          .shadow(radius: 5)
                        VStack(spacing: 20){
                            HStack{
                                Spacer()
                                Text("맞힌 한자")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 28))
                                Spacer()
                                Text("8개")
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
                                Text("8개")
                                    .foregroundStyle(.red)
                                //바꿀예정
                                    .font(.pretendardBold(size: 28))
                                Spacer()
                            }
                        }
                    }
                    .padding(.top, 72)
                    
                    Spacer()
                    NavyButton(title: "저장") {
                        // 네비게이션 패스 다 지워버리고 홈으로
                        // 결과 저장하는 로직
                    }
                    .padding(.bottom, 84)
                }
                .navigationTitle("1회차")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
    }
}

#Preview {
    ResultView()
}
