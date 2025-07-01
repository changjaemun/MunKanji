//
//  SwiftUIView.swift
//  MunKanji
//
//  Created by 문창재 on 6/5/25.
//

import SwiftUI
import SwiftData

struct LearningView: View {
    @State private var currentIndex: Int = 0
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    @Query
    private var kanjis: [Kanji]
    
    let learningStudyLogs: [StudyLog]
    
    // learningStudyLogs를 기반으로 실제 Kanji 객체 배열을 만듭니다.
    private var learningKanjis: [Kanji] {
        var tray: [Kanji] = []
        for log in learningStudyLogs {
            if let kanji = kanjis.first(where: { $0.id == log.kanjiID }) {
                tray.append(kanji)
            }
        }
        return tray
    }
    
    var body: some View {
        ZStack{
            Color.backGround
                .ignoresSafeArea()
            VStack {
                Spacer()
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            // 양쪽 여백 줘서 중앙 정렬
                            Spacer().frame(width: (UIScreen.main.bounds.width - 360) / 2)
                            
                            ForEach(learningKanjis, id: \.id) { kanji in
                                KanjiCardView(kanji: kanji)
                                    .scaleEffect(learningKanjis.firstIndex(of: kanji) == currentIndex ? 1.0 : 0.95)
                                    .opacity(learningKanjis.firstIndex(of: kanji) == currentIndex ? 1.0 : 0.6)
                                    .animation(.easeInOut(duration: 0.1), value: currentIndex)
                                    .id(kanji.id)
                            }
                            
                            Spacer().frame(width: (UIScreen.main.bounds.width - 338) / 2)
                        }
                    }
                    .scrollDisabled(true)
                    .onChange(of: currentIndex) { _, newValue in
                        withAnimation {
                            // learningKanjis의 id를 사용하여 스크롤합니다.
                            proxy.scrollTo(learningKanjis[newValue].id, anchor: .center)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    if value.translation.width > threshold && currentIndex > 0 {
                                        currentIndex -= 1
                                    } else if value.translation.width < -threshold && currentIndex < learningKanjis.count - 1 {
                                        currentIndex += 1
                                    }
                                }
                            }
                    )
                }
                
                Spacer()
                NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                    .padding()
                Spacer()
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton(action: {dismiss()})
                }
            }
        }
        
    }
}

#Preview {
    @State var path = NavigationPath()
    return LearningView(path: $path, learningStudyLogs: Dummy.studylog)
}
