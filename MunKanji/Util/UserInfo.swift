import Foundation
import SwiftUI

// MARK: - Study Mode
enum StudyMode: String, CaseIterable {
    case kanji = "kanji"
    case eumhun = "eumhun"

    var displayName: String {
        switch self {
        case .kanji: return "한자모드"
        case .eumhun: return "음훈모드"
        }
    }

    var primaryColor: Color {
        switch self {
        case .kanji: return .main
        case .eumhun: return .eumHunMode
        }
    }
}

// MARK: - User Settings
class UserSettings: ObservableObject {
    // 모드별 학습 개수 (각각 저장)
    @AppStorage("kanji_count_per_session") var kanjiCountPerSession = 10
    @AppStorage("eumhun_count_per_session") var eumhunCountPerSession = 5

    @Published var currentMode: StudyMode = .kanji

    // 현재 모드에 맞는 학습 개수
    var currentCountPerSession: Int {
        get {
            currentMode == .kanji ? kanjiCountPerSession : eumhunCountPerSession
        }
        set {
            if currentMode == .kanji {
                kanjiCountPerSession = newValue
            } else {
                eumhunCountPerSession = newValue
            }
        }
    }

    // 모드별 최소/최대값
    var minCount: Int { 5 }
    var maxCount: Int {
        currentMode == .kanji ? 30 : 15
    }
}
