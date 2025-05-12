//
//  KanjiCellView.swift
//  MunKanji
//
//  Created by 문창재 on 4/3/25.
//

import SwiftUI

struct KanjiCellView: View {
    //let word: Word?
    
    var body: some View {
        HStack{
            Spacer()
            Rectangle()
                .frame(width: 150, height: 150)
                .foregroundStyle(.white)
                .border(.black)
            Spacer()
            VStack(alignment: .leading){
                Text("글월 문")
                Text("부수: 문")
                Text("음: 분")
                Text("훈: 부")
            }
            Spacer()
        }
    }
}

#Preview {
    KanjiCellView()
}
