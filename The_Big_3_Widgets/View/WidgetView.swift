//
//  WidgetView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct WidgetView: View {
    let planner: Planner

    var body: some View {
        switch planner.state {
        case .planning: PlanPromptWidgetView()
        case .doing: WidgetPlanView(planner: planner)
        case .finished: WidgetSummationView(viewModel: planner.summationViewModel())
        }
    }
}

#if DEBUG
struct TheBig3WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetView(planner: Planner(plan: .example2))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetView(planner: Planner(plan: Plan(allowed: 3)))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
