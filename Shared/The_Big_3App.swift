//
//  The_Big_3App.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI

@main
struct The_Big_3App: App {
    
    @StateObject var planner = Planner(plan: .example)
    
    var body: some Scene {
        WindowGroup {
            ContentView(planner: planner)
                .accentColor(Color(hue: 5/8, saturation:21/34, brightness: 26/34))
        }
    }
}
