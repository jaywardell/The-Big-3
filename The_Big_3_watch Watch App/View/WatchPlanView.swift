//
//  WatchPlanView.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import SwiftUI

struct WatchPlanView: View {
    
    let planner: Planner
    
    var body: some View {
        VStack(spacing: 0) {
            Header(title: "The Big 3")
            ForEach(0..<ModelConstants.allowedGoalsPerPlan, id: \.self) { index in
                let todo = planner.todo(at: index)
                GoalView(todo: todo, backgroundColor: .accentColor, template: .watch(showDetail: {
                    print("\(todo.title) was tapped")
                }))
            }
        }
    }
}

struct WatchPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WatchPlanView(planner: Planner(plan: .example))
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
