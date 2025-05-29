//
//  ContentView.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("206")
                    .font(.system(size: 130))
                
                    .padding(.vertical, 169)
                NavigationLink{
                    StudyIntroView()
                }label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 285, height: 68)
                            .foregroundStyle(.indigo)
                            .cornerRadius(20)
                        Text("학습하기")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        //
                    }label: {
                        Image(systemName: "gearshape.fill")
                            .foregroundStyle(.indigo)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
