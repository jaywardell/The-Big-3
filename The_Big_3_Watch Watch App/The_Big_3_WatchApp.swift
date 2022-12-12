//
//  The_Big_3_WatchApp.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

@main
struct The_Big_3_Watch_Watch_AppApp: App {
    
    let model = WatchModel()
    
    var body: some Scene {
        WindowGroup {
            TheBig3WatchView(planner: model.planner)
                .accentColor(ViewConstants.tint)
        }
    }
}
