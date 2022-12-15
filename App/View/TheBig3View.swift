//
//  ContentView.swift
//  Shared
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI


struct TheBig3View: View {
    
    @ObservedObject var planner: Planner
    @Namespace private var animation

    
    var body: some View {
  
        Group {
            switch planner.state {
            case .planning:
                PlannerView(viewModel: planner.plannerViewModel())
            case .doing:
                AccomplishmentsView(viewModel: planner.accomplishmentsViewModel())
            case .finished:
                SummationView(viewModel: planner.summationViewModel())
            }
        }
        .environmentObject(AnimationNamespace(animation))
    }
}

final class AnimationNamespace: ObservableObject {
    let id: Namespace.ID
    
    init(_ id: Namespace.ID) {
        self.id = id
    }
    
    static var HeaderID: String { #function }
}
