//
//  QuizView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround.ignoresSafeArea()
                VStack(spacing:64){
                    Text("1 / 10")
                        .font(.system(size: 23, weight: .semibold))
                    Text("車")
                        .foregroundStyle(.main)
                        .font(.system(size: 80, weight: .semibold))
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
