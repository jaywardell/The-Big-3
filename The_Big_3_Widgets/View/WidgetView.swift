//
//  WidgetView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    let entry: Entry

    var body: some View {
        if entry.planner.plan.isFull {
            WidgetPlanView(planner: entry.planner)
        }
        else {
            PlanPromptWidgetView()
        }
    }
}

struct TheBig3WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(entry: Entry(planner: Planner(plan: .example2),
                          date: Date(),
                          configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetView(entry: Entry(planner: Planner(plan: Plan(allowed: 3)),
                          date: Date(),
                          configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
