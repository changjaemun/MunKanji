import SwiftUI

struct KanjiCardView: View {
    let kanji: Kanji
    let studyLog: StudyLog
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter
        }()
    
    func statusBarColor() -> Color {
        if studyLog.status == .incorrect {
            return .incorrect
        }
        
        if let nextReviewDate = studyLog.nextReviewDate, nextReviewDate <= Date() {
            return .point
        }
        
        return .white
    }
    
    var body: some View {
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                      .frame(width: 338, height: 360)
                      .cornerRadius(20)
                      .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    VStack{
                        Rectangle()
                            .foregroundStyle(statusBarColor()) // 리뷰, 새로운 한자, 틀린 한자 인지에 따라 색 변경
                            .frame(width: 338, height: 24)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        Spacer()
                    }.frame(height: 360)
                    VStack{
                        VStack{
                            Text(kanji.kanji)
                                .foregroundStyle(.main)
                                .font(.pretendardBold(size: 80))
                            Text(kanji.korean)
                                .foregroundStyle(.main)
                                .font(.pretendardRegular(size: 24))
                        }.frame(width: 338)
                            .padding(.bottom, 30)
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
                            }.padding(.horizontal)
                            Spacer()
                        }.padding()
                        
                    }.frame(width: 338, height: 388)
                    
                }
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

#Preview {
    let kanji = Kanji(id: 0, grade: "소학교 1학년", kanji: "車", korean: "수레 거, 수레 차", sound: "しゃ", meaning: "くるま")
    KanjiCardView(kanji: kanji, studyLog: StudyLog(kanjiID: 0))
        .background(.black)
}
