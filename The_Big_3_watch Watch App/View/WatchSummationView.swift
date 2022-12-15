//
//  WatchSummationView.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/15/22.
//

import SwiftUI

struct WatchSummationView: View {
    
    let planner: Planner
    
    var body: some View {
        VStack {
            
            GraphicSummary(viewModel: planner.graphicSummaryViewModel(),
                           layout: .circular)

        }
    }
}

struct WatchSummationView_Previews: PreviewProvider {
    static var previews: some View {
        WatchSummationView(planner: Planner(plan: .example2))
            .accentColor(.orange)
    }
}
