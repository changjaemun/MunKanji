//
//  EumHunQuizCardView.swift
//  MunKanji
//
//  Created by 문창재 on 2/5/26.
//

import SwiftUI

struct EumHunQuizCardView: View {
    let choice: EumHunChoice
    @ObservedObject var viewModel: EumHunQuizViewModel

    private var cardColor: Color {
        switch viewModel.isCorrect {
        case .unseen:
            return .miniCard
        case .correct:
            return choice == viewModel.currentCorrectAnswer ? .review : .miniCard
        case .incorrect:
            if choice == viewModel.currentCorrectAnswer {
                return .review
            } else if choice == viewModel.selectedAnswer {
                return .incorrect
            } else {
                return .miniCard
            }
        case .mastered:
            return .miniCard
        }
    }

    var body: some View {
        Button {
            viewModel.selectAnswer(choice: choice)
        } label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(cardColor)
                    .frame(width: 160, height: 160)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                Text(choice.sound)
                    .font(.pretendardSemiBold(size: 28))
                    .foregroundStyle(.fontBlack)
                    .minimumScaleFactor(0.5)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isCorrect != .unseen)
    }
}
