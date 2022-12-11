//
//  EventKitReminderUpdater.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import Combine

protocol EventKitReminderBridge {
    func checkUserAllowsAccess(_ completion: (Bool)->())
    func getReminder(for id: String) -> NSObject?
    func complete(_ object: NSObject)
}

final class EventKitReminderUpdater {
    
    let bridge: EventKitReminderBridge
    
    var subscriptions = Set<AnyCancellable>()
    
    init(bridge: EventKitReminderBridge) {
        self.bridge = bridge
        
        NotificationCenter.default.publisher(for: Plan.GoalWasCompleted).sink(receiveValue: goalWasCompleted)
            .store(in: &subscriptions)
    }
    
    private func goalWasCompleted(_ notification: Notification) {
        
        bridge.checkUserAllowsAccess { userAllowsAccess in
            guard userAllowsAccess,
                  let id = notification.userInfo?[Plan.GoalIDKey] as? String,
                  let reminder = bridge.getReminder(for: id) else { return }
            
            bridge.complete(reminder)
        }
    }
    
}
