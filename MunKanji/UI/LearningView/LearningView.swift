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
                GeometryReader { geo in
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(Array(learningKanjis.enumerated()), id: \.element.id) { (index, kanji) in
                                    GeometryReader { gr in
                                        let cardMidX = gr.frame(in: .global).midX
                                        let screenMidX = geo.size.width / 2
                                        let distance = abs(cardMidX - screenMidX)
                                        let minScale: CGFloat = 0.8
                                        let scale = max(minScale, 1 - (distance / screenMidX) * (1 - minScale))
                                        KanjiCardView(kanji: kanji)
                                            .scaleEffect(scale)
                                            .onTapGesture {
                                                withAnimation {
                                                    currentIndex = index
                                                    proxy.scrollTo(index, anchor: .center)
                                                }
                                            }
                                    }
                                    .frame(width: 338, height: 400)
                                    .id(index)
                                }
                            }
                            .padding(.horizontal, (geo.size.width - 338) / 2)
                        }
                        .content.offset(x: 0)
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    // 스크롤이 끝났을 때 가장 가까운 카드로 스냅
                                    let cardWidth: CGFloat = 338 + 20 // 카드+간격
                                    let offset = value.translation.width
                                    let estIndex = Int(round(CGFloat(currentIndex) - offset / cardWidth))
                                    let newIndex = min(max(estIndex, 0), learningKanjis.count - 1)
                                    withAnimation {
                                        currentIndex = newIndex
                                        proxy.scrollTo(newIndex, anchor: .center)
                                    }
                                }
                        )
                        .onAppear {
                            // 진입 시 현재 인덱스 카드로 이동
                            proxy.scrollTo(currentIndex, anchor: .center)
                        }
                        .onChange(of: currentIndex) { _, newValue in
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .center)
                            }
                        }
                    }
                }
                .frame(height: 420)
                Spacer()
                NavyNavigationLink(title: "퀴즈풀기", value: NavigationTarget.quiz(learningStudyLogs))
                    .padding()
                    .padding(.bottom, 20)
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
