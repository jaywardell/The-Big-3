//
//  The_Big_3App.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI

@main
struct The_Big_3App: App {
        
    let model = AppModel()
    
    @State private var showHistory = false
    
    var body: some Scene {
        WindowGroup {
            TheBig3View(planner: model.planner)
                .accentColor(Color(hue: 5/8, saturation:21/34, brightness: 26/34))
                .environment(\.showHistory, { showHistory.toggle() })
                .sheet(isPresented: $showHistory) {
                    LogView(viewModel: model.logger.historyViewModel())
                }
        }
    }
}


struct ShowHistoryKey: EnvironmentKey {
    static let defaultValue: ()->() = {}
}

extension EnvironmentValues {
    var showHistory: ()->() {
        get { self[ShowHistoryKey.self] }
        set { self[ShowHistoryKey.self] = newValue }
    }
}
