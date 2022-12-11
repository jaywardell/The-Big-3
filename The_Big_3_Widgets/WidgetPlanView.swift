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
        case .systemSmall: return .small
        case .systemMedium,
                .systemLarge,
                .systemExtraLarge: return .medium
        default: return .small
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<AppConstants.allowedGoalsPerPlan, id: \.self) { index in
                let todo = planner.todo(at: index)
                GoalView(todo: todo, backgroundColor: .accentColor, postpone: {}, finish: {}, template: template(for: widgetFamily))
            }
        }
    }
}

struct WidgetPlanView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPlanView(planner: Planner(plan: .example))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("none completed")

        WidgetPlanView(planner: Planner(plan: .example2))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("some completed")
    }
}
