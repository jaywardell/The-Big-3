//
//  The_Big_3_Widgets.swift
//  The_Big_3_Widgets
//
//  Created by Joseph Wardell on 12/11/22.
//

import WidgetKit
import SwiftUI
import Intents

//struct Provider: IntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
//    }
//
//    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
//        let entry = SimpleEntry(date: Date(), configuration: configuration)
//        completion(entry)
//    }
//
//    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        let timeline = Timeline(entries: entries, policy: .atEnd)
//        completion(timeline)
//    }
//}

//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationIntent
//}

struct The_Big_3_WidgetsEntryView : View {
    var entry: TheBig3TimelineProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct The_Big_3_Widgets: Widget {
    let kind: String = "The_Big_3_Widgets"

    let model = WidgetModel()
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: TheBig3TimelineProvider(model: model)) { entry in
//            The_Big_3_WidgetsEntryView(entry: entry)
            TheBig3WidgetView(entry: entry)
                .accentColor(ViewConstants.tint)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("The Big 3")
        .description("Track your progress on your Big 3")
    }
}

struct The_Big_3_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        The_Big_3_WidgetsEntryView(entry: Entry(planner: Planner(plan: .example), date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
