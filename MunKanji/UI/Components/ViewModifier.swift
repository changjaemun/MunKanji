//
//  ViewModifier.swift
//  MunKanji
//
//  Created by 문창재 on 8/19/25.
//
import SwiftUI

struct StudyIntroTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.pretendardLight(size: 24))
            .foregroundStyle(.introFont)
    }
}

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
    }
}

