//
//  SwiftUIView.swift
//  MunKanji
//
//  Created by 문창재 on 6/5/25.
//

import SwiftUI

struct LearningView: View {
    
    var body: some View {
        NavigationStack{
            VStack{
                TabView {
                    ForEach(1...10, id: \.self) { i in
                                KanjiCardView()
                            }
                        }
                        .tabViewStyle(.page)
                NavyNavigationLink(title: "퀴즈풀기", destination: EmptyView())
                Spacer()
            }
        }
    }
}

#Preview {
    LearningView()
}
