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
                        .frame(width: 331, height: 222)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    VStack(spacing: 22) {
                        HStack{
                            Circle()
                                .fill(.incorrect)
                                .frame(width: 12)
                                .padding(.trailing, 10)
                            Text("틀렸던 한자")
                                .font(.pretendardLight(size: 24))
                                .foregroundStyle(.introFont)
                            HStack(spacing: 4) {
                                    Text("\(inCorrectKanjisCount)")
                                        .foregroundStyle(.main)
                                        .font(.pretendardSemiBold(size: 24))
                                    Text("개")
                                        .foregroundStyle(.main)
                                        .font(.pretendardLight(size: 24))
                                }
                                .padding(.leading, 76)
                        }
                        
                        HStack{
                            Circle()
                                .fill(.point)
                                .frame(width: 12)
                                .padding(.trailing, 10)
                            Text("복습할 한자")
                                .font(.pretendardLight(size: 24))
                                .foregroundStyle(.introFont)
                            HStack(spacing: 4) {
                                    Text("\(reviewKanjisCount)")
                                        .foregroundStyle(.main)
                                        .font(.pretendardSemiBold(size: 24))
                                    Text("개")
                                        .foregroundStyle(.main)
                                        .font(.pretendardLight(size: 24))
                                }
                                .padding(.leading, 76)
                        }
                        HStack{
                            Circle()
                                .fill(.main)
                                .frame(width: 12)
                                .padding(.trailing, 10)
                            Text("새로운 한자")
                                .foregroundStyle(.introFont)
                                .font(.pretendardLight(size: 24))
                            HStack(spacing: 4) {
                                    Text("\(unseenKanjisCount)")
                                        .foregroundStyle(.main)
                                        .font(.pretendardSemiBold(size: 24))
                                    Text("개")
                                        .foregroundStyle(.main)
                                        .font(.pretendardLight(size: 24))
                                }
                                .padding(.leading, 76)
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
