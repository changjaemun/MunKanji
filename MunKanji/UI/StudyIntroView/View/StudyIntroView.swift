//
//  StudyIntroView.swift
//  MunKanji
//
//  Created by 문창재 on 5/28/25.
//

import SwiftUI
import SwiftData
import Charts

// MARK: - 차트 데이터 모델
struct StudyChartData: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
    let color: Color
}

struct StudyIntroView: View {
    @EnvironmentObject var userSettings: UserSettings
    @ObservedObject var viewModel: StudyIntroViewModel

    @Binding var path: NavigationPath

    // 차트 데이터
    var chartData: [StudyChartData] {
        [
            StudyChartData(
                category: "틀림",
                count: viewModel.inCorrectKanjisCount(mode: userSettings.currentMode, countPerSession: userSettings.currentCountPerSession),
                color: .incorrect
            ),
            StudyChartData(
                category: "복습",
                count: viewModel.reviewKanjisCount(mode: userSettings.currentMode, countPerSession: userSettings.currentCountPerSession),
                color: .review
            ),
            StudyChartData(
                category: "신규",
                count: viewModel.unseenKanjisCount(mode: userSettings.currentMode, countPerSession: userSettings.currentCountPerSession),
                color: .newKanji
            )
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 40)

            // 스테퍼
            KanjiCountStepper()

            Spacer()
            
            // 차트
            StudyBarChart(data: chartData)
                .frame(height: 280)
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 20)

            Spacer()

            // 학습시작 버튼
            NavyNavigationLink(title: "학습시작", value: NavigationTarget.learning)
                .font(.pretendardSemiBold(size: 24))
                .containerRelativeFrame(.horizontal) { width, _ in
                    min(width * 0.75, 320)
                }
                .frame(height: 68)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

// MARK: - 막대 차트
struct StudyBarChart: View {
    let data: [StudyChartData]

    // 카테고리 순서 고정
    private let categories = ["틀림", "복습", "신규"]

    // 최대값 계산 (Y축 스케일용)
    var maxCount: Int {
        max(data.map { $0.count }.max() ?? 1, 1)
    }

    var body: some View {
        Chart {
            // 막대 차트
            ForEach(data) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Count", item.count),
                    width: 60
                )
                .foregroundStyle(item.color)
                .cornerRadius(4)
                .annotation(position: .top) {
                    Text("\(item.count)")
                        .font(.pretendardLight(size: 16))
                        .foregroundStyle(.fontBlack)
                }
            }

            // 하단 기준선
            RuleMark(y: .value("Baseline", 0))
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(Color.fontBlack.opacity(0.2))
        }
        .chartXScale(domain: categories)  // X축 카테고리 고정
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisValueLabel()
                    .font(.pretendardMedium(size: 16))
                    .foregroundStyle(.fontBlack)
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(domain: 0...(maxCount + 3))
        .animation(.snappy(duration: 0.3), value: data.map { $0.count })
    }
}

// MARK: - 스테퍼
struct KanjiCountStepper: View {
    @EnvironmentObject var userSettings: UserSettings

    var canDecrease: Bool {
        userSettings.currentCountPerSession > userSettings.minCount
    }

    var canIncrease: Bool {
        userSettings.currentCountPerSession < userSettings.maxCount
    }

    var body: some View {
        HStack(spacing: 24) {
            // 마이너스 버튼
            Button {
                if canDecrease {
                    userSettings.currentCountPerSession -= 5
                }
            } label: {
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(canDecrease ? Color.fontBlack : Color.gray.opacity(0.4))
                    )
            }
            .disabled(!canDecrease)
            .buttonStyle(.plain)

            // 숫자 표시
            VStack(spacing: 2) {
                Text("\(userSettings.currentCountPerSession)")
                    .font(.pretendardBold(size: 40))
                    .foregroundStyle(.fontBlack)
                    .contentTransition(.numericText())
                    .animation(.snappy(duration: 0.2), value: userSettings.currentCountPerSession)
                Text("개 학습")
                    .font(.pretendardRegular(size: 14))
                    .foregroundStyle(.fontGray)
            }
            .frame(width: 100)

            // 플러스 버튼
            Button {
                if canIncrease {
                    userSettings.currentCountPerSession += 5
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(canIncrease ? Color.fontBlack : Color.gray.opacity(0.4))
                    )
            }
            .disabled(!canIncrease)
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        StudyIntroView(
            viewModel: StudyIntroViewModel(studyLogs: [], eumhunStudyLogs: []),
            path: $path
        )
        .environmentObject(UserSettings())
    }
}
