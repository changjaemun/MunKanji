//
//  StudyIntroView.swift
//  MunKanji
//
//  Created by 문창재 on 5/28/25.
//

import SwiftUI
import SwiftData

struct StudyIntroView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    @EnvironmentObject var userCurrentSession: UserCurrentSession
    
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    @Query
    var studyLogs: [StudyLog]
    
    private var learningStudyLogs:[StudyLog]{
        
        let incorrectStudyLogs: [StudyLog] = {
            return studyLogs
                .filter { $0.status == .incorrect }
                .sorted { $0.kanjiID < $1.kanjiID }
        }()
        
        let reviewStudyLogs: [StudyLog] = {
            return studyLogs
                .filter {
                    if let nextReviewDate = $0.nextReviewDate {
                        return nextReviewDate <= Date()
                    }
                    return false
                }
                .sorted { $0.kanjiID < $1.kanjiID }
        }()
        
        let unseenStudyLogs: [StudyLog] = {
            return studyLogs
                .filter { $0.status == .unseen}
                .sorted { $0.kanjiID < $1.kanjiID }
        }()
        
        let tray = Array(incorrectStudyLogs + reviewStudyLogs + unseenStudyLogs).prefix(userSettings.kanjiCountPerSession)
        
        return Array(tray)
    }
    
    private var inCorrectKanjisCount:Int{
        learningStudyLogs.filter{$0.status == .incorrect}.count
    }
    
    private var reviewKanjisCount:Int{
        learningStudyLogs.filter{ if $0.nextReviewDate != nil {return true} else {return false}}.count
    }
    
    private var unseenKanjisCount:Int{
        learningStudyLogs.filter{$0.status == .unseen}.count
    }
    
    var body: some View {
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
                                .font(.pretendardRegular(size: 14))
                            Text("\(unseenKanjisCount)개")
                                .padding(.vertical, 3)
                                .font(.pretendardSemiBold(size: 48))
                            //unseen보다 틀린 한자 부터 쭉 찾아야겠지?
                        }
                        VStack{
                            Text("틀렸던 한자")
                                .font(.pretendardRegular(size: 14))
                            Text("\(inCorrectKanjisCount)개")
                                .padding(.vertical, 3)
                                .foregroundStyle(.point)
                                .font(.pretendardSemiBold(size: 48))
                        }
                        
                        VStack{
                            Text("리뷰 한자")
                                .font(.pretendardRegular(size: 14))
                            Text("\(reviewKanjisCount)개")
                                .padding(.vertical, 3)
                                .foregroundStyle(.point)
                                .font(.pretendardSemiBold(size: 48))
                        }
                    }
                }
                .padding(.vertical, 195)
                NavyNavigationLink(title: "학습시작", value: NavigationTarget.learning(learningStudyLogs))
            }.navigationBarBackButtonHidden()
                .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton(action: { dismiss() })
                }
            }
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    return StudyIntroView(path: $path)
        .environmentObject(UserSettings())
        .environmentObject(UserCurrentSession())
}
