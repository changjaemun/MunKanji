//
//  StudyIntroView.swift
//  MunKanji
//
//  Created by 문창재 on 5/28/25.
//

import SwiftUI

struct StudyIntroView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 331, height: 211)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                        HStack(spacing: 59) {
                            VStack{
                                Text("외울 한자")
                                    .font(.pretendardRegular(size: 14))
                                Text("8개")
                                    .padding(.vertical, 3)
                                    .font(.pretendardSemiBold(size: 48))
                            }
                            VStack{
                                Text("복습할 한자")
                                    .font(.pretendardRegular(size: 14))
                                Text("8개")
                                    .padding(.vertical, 3)
                                    .foregroundStyle(.point)
                                    .font(.pretendardSemiBold(size: 48))
                            }
                        }
                    }
                    .padding(.vertical, 195)
                    NavyNavigationLink(title: "학습시작", destination: LearningView())
                }
            }
        }
    }
}

#Preview {
    StudyIntroView()
}
