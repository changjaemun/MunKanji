import Foundation
import SwiftUI

class UserSettings: ObservableObject {
    @AppStorage("kanji_count_per_session") var kanjiCountPerSession = 10
} 

class UserCurrentSession: ObservableObject {
    @AppStorage("currentSessionNumber") var currentSessionNumber = 1
}
