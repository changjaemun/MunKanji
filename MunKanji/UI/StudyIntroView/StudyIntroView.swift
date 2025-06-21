//
//  StudyIntroView.swift
//  MunKanji
//
//  Created by 문창재 on 5/28/25.
//

import SwiftUI
import SwiftData

struct StudyIntroView: View {
    
    let kanjiCount:Int = 10
    
    @Query
    var studyLogs: [StudyLog]
    
    var learningStudyLogs:[StudyLog]{
        Array(studyLogs.filter{$0.status != .correct}.sorted(){$0.kanjiID < $1.kanjiID}.prefix(kanjiCount))
    }
    
    var inCorrectKanjisCount:Int{
        learningStudyLogs.filter{$0.status == .incorrect}.count
    }
    
    var unseenKanjisCount:Int{
        kanjiCount - inCorrectKanjisCount
    }
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.backGround
                    .ignoresSafeArea()
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundStyle(.white)
                            .frame(width: 331, height: 211)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        HStack(spacing: 59) {
                            VStack{
                                Text("외울 한자")
                                    .font(.system(size: 14))
                                Text("\(unseenKanjisCount)개")
                                    .padding(.vertical, 3)
                                    .font(.system(size: 48, weight: .semibold))
                                //unseen보다 틀린 한자 부터 쭉 찾아야겠지?
                            }
                            VStack{
                                Text("틀렸던 한자")
                                    .font(.system(size: 14))
                                Text("\(inCorrectKanjisCount)개")
                                    .padding(.vertical, 3)
                                    .foregroundStyle(.point)
                                    .font(.pretendardSemiBold(size: 48))
                            }
                        }
                    }
                    .padding(.vertical, 195)
                    NavyNavigationLink(title: "학습시작", destination: LearningView(learningStudyLogs: learningStudyLogs))
                }
            }
        }
    }
}

#Preview {
    StudyIntroView()
}
