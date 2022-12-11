//
//  PlanPromptWidgetView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct PlanPromptWidgetView: View {
    var body: some View {
        VStack {
            Text("Plan the Next")
                .font(.system(.caption2, design: .default, weight: .ultraLight))
            Text("Big")
                .font(.system(.largeTitle, design: .default, weight: .ultraLight)) +
            Text("3")
                .font(.system(.largeTitle, design: .monospaced, weight: .black))
                .bold()
                .foregroundColor(.accentColor)
        }
    }
}

struct PlanPromptWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanPromptWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
