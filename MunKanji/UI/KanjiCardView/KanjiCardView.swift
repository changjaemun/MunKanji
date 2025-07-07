import SwiftUI

struct KanjiCardView: View {
    let kanji: Kanji
    
    var body: some View {
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                      .frame(width: 338, height: 360)
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
                            VStack(alignment:.leading, spacing: 20){
                                Text("음: \(kanji.sound)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                                Text("훈: \(kanji.meaning)")
                                    .foregroundStyle(.main)
                                    .font(.pretendardRegular(size: 24))
                            }.padding()
                            Spacer()
                        }.padding()
                        
                    }.frame(width: 338, height: 388)
                    
                }
        }
    }

#Preview {
    let kanji = Kanji(id: 0, grade: "소학교 1학년", kanji: "車", korean: "수레 거, 수레 차", sound: "しゃ", meaning: "くるま")
    KanjiCardView(kanji: kanji)
}
