//
//  MunKanjiApp.swift
//  MunKanji
//
//  Created by 문창재 on 3/26/25.
//

import SwiftUI

@main
struct MunKanjiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct MainView: View{
    var body: some View{
        TabView{
            Tab("Daily", systemImage: "gear"){
                ContentView()
            }
            Tab("Dictionary", systemImage: "gear"){
                //DictionaryView()
            }
            Tab("설정", systemImage: "gear"){
                Button(action: {
                    let result = JsonManager.shared.load(fileName: "characters")
                    print(result)
                    var wordList = JsonManager.shared.getWordsFromData(jsonWordFileData: result!)
                    
                    guard var wordList = wordList else {
                        return
                    }
                    wordList.sort(by: { $0.grade!.split(separator: " ")[1].first! < $1.grade!.split(separator: " ")[1].first!})
                    print(wordList)
                    
                    JsonManager.shared.saveWordsToJSONFile(words: wordList)
                }) {
                    Text("test")
                }
            }
        }
    }
}

#Preview(body: {
    MainView()
})
