//
//  SwiftUIView.swift
//  MunKanji
//
//  Created by 문창재 on 6/5/25.
//

import SwiftUI

struct LearningView: View {
    @State private var currentIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            // 양쪽 여백 줘서 중앙 정렬
                            Spacer().frame(width: (UIScreen.main.bounds.width - 360) / 2)
                            
                            ForEach(0..<3, id: \.self) { index in
                                KanjiCardView()
                                    .scaleEffect(index == currentIndex ? 1.0 : 0.95)
                                    .opacity(index == currentIndex ? 1.0 : 0.6)
                                    .animation(.easeInOut(duration: 0.3), value: currentIndex)
                                    .id(index)
                            }
                            
                            Spacer().frame(width: (UIScreen.main.bounds.width - 338) / 2)
                        }
                    }
                    .scrollDisabled(true)
                    .onChange(of: currentIndex) { _, newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if value.translation.width > threshold && currentIndex > 0 {
                                        currentIndex -= 1
                                    } else if value.translation.width < -threshold && currentIndex < 2 {
                                        currentIndex += 1
                                    }
                                }
                            }
                    )
                }
                
                Spacer()
                NavyNavigationLink(title: "퀴즈풀기", destination: EmptyView())
                    .padding()
                Spacer()
            }
        }
    }
}

#Preview {
    LearningView()
}
