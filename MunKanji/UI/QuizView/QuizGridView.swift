//
//  Untitled.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//
import SwiftUI

struct QuizGridView: View {
    let koreans = ["수레 차", "불 화", "물 수", "산 산"]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(koreans, id: \.self) { korean in
                QuizCardView(korean: korean)
            }
        }
    }
}
