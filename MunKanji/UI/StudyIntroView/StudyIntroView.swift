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
    
    @Query var studyLogs: [StudyLog]
    
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
        VStack{
            Spacer()
            StudyInfoCountInfoView(inCorrectKanjisCount: inCorrectKanjisCount, reviewKanjisCount: reviewKanjisCount, unseenKanjisCount: unseenKanjisCount)
            Spacer()
            NavyNavigationLink(title: "학습시작", value: NavigationTarget.learning(learningStudyLogs))
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .navigationTitle("\(userCurrentSession.currentSessionNumber)회차")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton(action: { dismiss() })
            }
        }
    }
}
