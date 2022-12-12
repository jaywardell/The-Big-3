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
        if planner.plan.isFull {
//            WidgetPlanView(planner: entry.planner)
            Text("There are some goals to see")
        }
        else {
            NoPlanView()
        }
    }
}

struct TheBig3WatchView_Previews: PreviewProvider {
    static var previews: some View {
        TheBig3WatchView(planner: Planner(plan: .example2))

        TheBig3WatchView(planner: Planner(plan: .emptyExample))
    }
}
