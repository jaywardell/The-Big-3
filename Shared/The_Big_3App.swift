//
//  The_Big_3App.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI

@main
struct The_Big_3App: App {
    
    @StateObject var planner = Planner()
    
    var body: some Scene {
        WindowGroup {
            switch planner.state {
            case .planning:
                PlannerView(viewModel: planner.plannerViewModel())
            case .doing:
                AccomplishmentsView(viewModel: planner.accomplishmentsViewModel())
            }
            
        }
    }
}
