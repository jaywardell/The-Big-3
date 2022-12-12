//
//  The_Big_3_watchApp.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

@main
struct The_Big_3_watch_Watch_AppApp: App {
    
    let model = WatchModel()
    
    var body: some Scene {
        WindowGroup {
            TheBig3WatchView(planner: model.planner)
        }
    }
}
