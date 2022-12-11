//
//  EventKitReminderUpdater.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import Combine

protocol EventKitReminderBridge {
    func getReminder(for id: String)
}

final class EventKitReminderUpdater {
    
    let bridge: EventKitReminderBridge
    
    var subscriptions = Set<AnyCancellable>()
    
    init(bridge: EventKitReminderBridge) {
        self.bridge = bridge
        
        NotificationCenter.default.publisher(for: Plan.GoalWasCompleted).sink(receiveValue: goalWasCompleted)
            .store(in: &subscriptions)
    }
    
    private func goalWasCompleted(_ unused: Any) {
        bridge.getReminder(for: "")
    }
    
}
