//
//  TheBig3TimelineProvider.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation
import WidgetKit

final class WidgetTimelineProvider: IntentTimelineProvider {
    
    let model: WidgetModel
    
    init(model: WidgetModel) {
        self.model = model
    }
    
    func placeholder(in context: Context) -> Entry {
        return Entry(planner: Planner(plan: .widgetPlaceholderExample), date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> ()) {
                
        completion(placeholder(in: context))
    }


    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [Entry] = [Entry(planner: model.planner, date: Date(), configuration: configuration)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct Entry: TimelineEntry {
    let planner: Planner
    let date: Date
    let configuration: ConfigurationIntent
}
