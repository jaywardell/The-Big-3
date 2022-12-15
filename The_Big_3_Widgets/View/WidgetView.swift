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
        switch entry.planner.state {
        case .planning: PlanPromptWidgetView()
        case .doing: WidgetPlanView(planner: entry.planner)
        case .finished: WidgetSummationView(viewModel: entry.planner.summationViewModel())
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
