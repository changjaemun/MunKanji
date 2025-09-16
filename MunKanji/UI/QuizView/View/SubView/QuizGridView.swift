//
//  Untitled.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//
import SwiftUI
import SwiftData

struct QuizGridView: View {
    @ObservedObject var viewModel: QuizViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.choices, id: \.self) { choice in
                QuizCardView(
                    korean: choice,
                    viewModel: viewModel
                )
            }
        }
    }
}
