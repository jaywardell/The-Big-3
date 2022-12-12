//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI


struct TheBig3View: View {
    
    @ObservedObject var planner: Planner
    
    
    var body: some View {
  
        switch planner.state {
        case .planning:
            PlannerView(viewModel: planner.plannerViewModel())
        case .doing:
            AccomplishmentsView(viewModel: planner.accomplishmentsViewModel())
        }
    }
}
