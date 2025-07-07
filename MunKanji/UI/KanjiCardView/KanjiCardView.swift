import SwiftUI

struct KanjiCardView: View {
    let kanji: Kanji
    
    var body: some View {
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                      .frame(width: 338, height: 400)
                      .cornerRadius(20)
                      .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    VStack{
                        VStack{
                            Text(kanji.kanji)
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 80))
                            Text(kanji.korean)
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                        }.frame(width: 338)
                            .padding(.bottom)
                        Divider()
                            .frame(width: 310)
                        HStack{
                            VStack(alignment:.leading){
                                Text("음: \(kanji.sound)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                                    .padding(10)
                                Text("훈: \(kanji.meaning)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                                    .padding(10)
                            }.padding()
                            Spacer()
                        }
                        
                    }.frame(width: 338, height: 400)
                    
                }
        }
    }

#Preview {
    let kanji = Kanji(id: 0, grade: "소학교 1학년", kanji: "車", korean: "수레 거, 수레 차", sound: "しゃ", meaning: "くるま")
    KanjiCardView(kanji: kanji)
}
