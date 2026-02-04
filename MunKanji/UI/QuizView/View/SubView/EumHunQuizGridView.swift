//
//  EumHunQuizGridView.swift
//  MunKanji
//
//  Created by 문창재 on 2/5/26.
//

import SwiftUI

struct EumHunQuizGridView: View {
    @ObservedObject var viewModel: EumHunQuizViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.choices, id: \.self) { choice in
                EumHunQuizCardView(
                    choice: choice,
                    viewModel: viewModel
                )
            }
        }
    }
}
