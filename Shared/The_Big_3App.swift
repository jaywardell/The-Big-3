//
//  The_Big_3App.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI

@main
struct The_Big_3App: App {
    
    let planner = Planner()
    
    var body: some Scene {
        WindowGroup {
            PlannerView(viewModel: planner.plannerViewModel())
        }
    }
}
