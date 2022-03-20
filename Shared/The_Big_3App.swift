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
                        Label("The Big 3", systemImage: "3.circle")
                    }

                LogView()
                    .tabItem {
                        Label("Completed", systemImage: "list.bullet")
                    }

            }
            .accentColor(Color(hue: 5/8, saturation:21/34, brightness: 26/34))
            .tabViewStyle(.automatic)
        }
    }
}
