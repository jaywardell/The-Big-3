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
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TheBig3View(planner: model.planner)
                    .tabItem {
                        Label("Today's Plan", systemImage: "3.circle")
                    }
                    .accentColor(Color(hue: 5/8, saturation:21/34, brightness: 26/34))

                LogView()
                    .tabItem {
                        Label("History", systemImage: "list.bullet")
                    }

            }
            .tabViewStyle(.automatic)
        }
    }
}
