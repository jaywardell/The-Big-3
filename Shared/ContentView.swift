//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI


struct ContentView: View {
    
    @ObservedObject var planner: Planner
    
    @ViewBuilder private var content: some View {
        switch planner.state {
        case .planning:
            PlannerView(viewModel: planner.plannerViewModel())
        case .doing:
            AccomplishmentsView(viewModel: planner.accomplishmentsViewModel())
        }
    }
    
    var body: some View {
        
        #if os(macOS)
        content
        #else
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                content
            }
        }
        else {
            content
        }
        #endif
    }
}
