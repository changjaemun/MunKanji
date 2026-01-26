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
    @AppStorage("kanji_count_per_session") var kanjiCountPerSession = 10
    @Published var currentMode: StudyMode = .kanji
}

class UserCurrentSession: ObservableObject {
    @AppStorage("currentSessionNumber") var currentSessionNumber = 1
}
