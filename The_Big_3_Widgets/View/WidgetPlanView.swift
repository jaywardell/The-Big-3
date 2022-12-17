//
//  WidgetPlanView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct WidgetPlanView: View {
    
    let planner: Planner
    
    @Environment(\.widgetFamily) var widgetFamily

    private func template(for family: WidgetFamily) -> GoalView.Template {
        switch family {
        case .systemSmall: return .minimalWidget
        case .systemMedium,
                .systemLarge,
                .systemExtraLarge: return .veboseWidget
        default: return .minimalWidget
        }
    }
    
    var body: some View {
        if widgetFamily == .accessoryRectangular {
            VStack {
                BrandedHeader(layout: .inlinemain)
                    .padding(.bottom, 2)
                GraphicSummary(viewModel: planner.graphicSummaryViewModel(), layout: .small)
                    .font(.headline)
                    .bold()
            }
        }
        else if widgetFamily == .accessoryInline {
            let completed: Int = planner.plan.currentGoals.reduce(0) { $0 + ($1?.state == .completed ? 1 : 0) }
            Text("\(completed) out of \(planner.plan.allowed)")
        }
        else if widgetFamily == .accessoryCircular {
            GraphicSummary(viewModel: planner.graphicSummaryViewModel(), layout: .circular)
        }
        else {
            VStack(spacing: 0) {
                ForEach(0..<ModelConstants.allowedGoalsPerPlan, id: \.self) { index in
                    let todo = planner.todo(at: index)
                    GoalView(todo: todo, backgroundColor: .accentColor, template: template(for: widgetFamily))
                }
            }
        }
    }
}

#if DEBUG
struct WidgetPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPlanView(planner: Planner(plan: .example))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("none completed")

        WidgetPlanView(planner: Planner(plan: .example2))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("some completed")

        WidgetPlanView(planner: Planner(plan: .example))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("none completed")

        WidgetPlanView(planner: Planner(plan: .example2))
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .previewDisplayName("some completed")

        WidgetPlanView(planner: Planner(plan: .example))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("none completed")

        WidgetPlanView(planner: Planner(plan: .example2))
            .previewContext(WidgetPreviewContext(family: .accessoryInline))
            .previewDisplayName("some completed")
    }
}
#endif
