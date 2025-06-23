//
//  QuizCardView.swift
//  MunKanji
//
//  Created by 문창재 on 6/8/25.
//

import SwiftUI

struct QuizCardView: View {
    let korean: String
    @ObservedObject var viewModel: QuizViewModel
    
    private var cardColor: Color {
        switch viewModel.isCorrect {
        case .unseen:
            return .miniCard
        case .correct:
            // 정답을 선택한 경우: 선택한 답안만 초록색
            return korean == viewModel.currentCorrectAnswer ? .accent : .miniCard
        case .incorrect:
            // 오답을 선택한 경우: 정답은 초록색, 선택한 오답은 빨간색
            if korean == viewModel.currentCorrectAnswer {
                return .accent // 정답 표시
            } else if korean == viewModel.selectedAnswer {
                return .red // 선택한 오답 표시
            } else {
                return .miniCard
            }
        }
    }
    
    var body: some View {
        Button {
            viewModel.selectAnswer(selectedAnswer: korean)
        } label: {
            ZStack {
                Rectangle()
                    .foregroundStyle(cardColor)
                    .frame(width: 160, height: 160)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                
                Text(korean)
                    .font(.pretendardSemiBold(size: 24))
                    .foregroundStyle(.main)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isCorrect != .unseen) // 답안 선택 후 버튼 비활성화
    }
}

