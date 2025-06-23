import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage("kanji_count_per_session") var kanjiCountPerSession = 10
} 