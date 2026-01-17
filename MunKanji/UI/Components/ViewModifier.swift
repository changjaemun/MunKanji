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
            .foregroundStyle(.white)
            .cornerRadius(20)
            .shadow(radius: 10, x: 4, y: 4)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct BackgroundStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.backGround)
            .ignoresSafeArea()
    }
}
