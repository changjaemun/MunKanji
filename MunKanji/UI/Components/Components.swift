//
//  Components.swift
//  MunKanji
//
//  Created by 문창재 on 5/29/25.
//

import SwiftUI


struct NavyNavigationLink<Destination: View>:View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(.main)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text("\(title)")
                    .foregroundStyle(.white)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct GrayNavigationLink<Destination: View>:View {
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 60)
                    .foregroundStyle(.backGround)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text("\(title)")
                    .foregroundStyle(.black)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

struct NavyButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button{
            action()
        }label: {
            ZStack{
                Rectangle()
                    .frame(width: 285, height: 68)
                    .foregroundStyle(.main)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                Text("\(title)")
                    .foregroundStyle(.white)
                    .font(.pretendardRegular(size: 24))
            }
        }
    }
}

#Preview(body: {
    NavyNavigationLink(title: "테스트 버튼", destination: EmptyView())
})
