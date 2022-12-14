//
//  PlanPromptWidgetView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import SwiftUI
import WidgetKit

struct PlanPromptWidgetView: View {

    @Environment(\.widgetFamily) var widgetFamily

    
    var body: some View {
        if widgetFamily == .accessoryRectangular {
            BrandedHeader(layout: .minisquare)
        }
        else if widgetFamily == .accessoryInline {
            BrandedHeader(layout: .inline)
        }
        else {
            VStack {
                
                if widgetFamily == .systemLarge {
                    Spacer()
                }
                
                HStack {
                    BrandedHeader(layout: .square)
                    .padding()
                    .padding()
                    
                    if [.systemMedium, .systemExtraLarge].contains(widgetFamily) {
                        Spacer()
                    }
                }
                
                if [.systemMedium,
                    .systemLarge, .systemExtraLarge].contains(widgetFamily) {
                    Spacer()
                    Spacer()
                }
            }
        }
    }
}

struct PlanPromptWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        PlanPromptWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        PlanPromptWidgetView()
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
