//
//  TheBig3WidgetView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct TheBig3WidgetView: View {
    let entry: Entry

    var body: some View {
        if entry.planner.plan.isFull {
            WidgetPlanView(planner: entry.planner)
        }
        else {
            VStack {
                Text("Plan the Next")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Text("Big 3")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.accentColor)
            }
        }
    }
}

struct TheBig3WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        TheBig3WidgetView(entry: Entry(planner: Planner(plan: .example2),
                          date: Date(),
                          configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))

        TheBig3WidgetView(entry: Entry(planner: Planner(plan: Plan(allowed: 3)),
                          date: Date(),
                          configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
