//
//  The_Big_3_Widgets.swift
//  The_Big_3_Widgets
//
//  Created by Joseph Wardell on 12/11/22.
//

import WidgetKit
import SwiftUI
import Intents


//struct The_Big_3_WidgetsEntryView : View {
//    var entry: TheBig3TimelineProvider.Entry
//
//    var body: some View {
//        Text(entry.date, style: .time)
//    }
//}

@main
struct The_Big_3_Widgets: Widget {
    let kind: String = "The_Big_3_Widgets"

    let model = WidgetModel()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: TheBig3TimelineProvider(model: model)) { entry in
            TheBig3WidgetView(entry: entry)
                .accentColor(ViewConstants.tint)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("The Big 3")
        .description("Track your progress on your Big 3")
    }
}
