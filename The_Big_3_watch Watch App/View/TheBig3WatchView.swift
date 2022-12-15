//
//  TheBig3WatchView.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

struct TheBig3WatchView: View {
    
    @ObservedObject var planner: Planner

    var body: some View {
        switch planner.state {
        case .planning: NoPlanView()
        case .doing: WatchPlanView(viewModel: planner.watchPlanViewModel())
        case .finished: WatchSummationView(planner: planner)
        }
//        if planner.state == .planning {
//            NoPlanView()
//        }
//        else {
//            WatchPlanView(viewModel: planner.watchPlanViewModel())
//        }
    }
}

struct TheBig3WatchView_Previews: PreviewProvider {
    static var previews: some View {
        TheBig3WatchView(planner: Planner(plan: .example2))
            .previewDisplayName("Plan is ready")

        TheBig3WatchView(planner: Planner(plan: .emptyExample))
            .previewDisplayName("Empty Plan")
    }
}
