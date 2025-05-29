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
                Color.gray
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 331, height: 211)
                            .cornerRadius(20)
                        HStack(spacing: 59) {
                            VStack{
                                Text("외울 한자")
                                    .font(.system(size: 14))
                                Text("8개")
                                    .padding(.vertical, 3)
                                    .font(.system(size: 48))
                            }
                            VStack{
                                Text("외울 한자")
                                    .font(.system(size: 14))
                                Text("8개")
                                    .padding(.vertical, 3)
                                    .font(.system(size: 48))
                            }
                        }
                    }
                    .padding(.vertical, 195)
                    NavyNavigationLink(title: "학습시작", destination: EmptyView())
                }
            }
        }
    }
}

#Preview {
    StudyIntroView()
}
