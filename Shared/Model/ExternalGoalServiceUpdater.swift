//
//  ExternalGoalServiceUpdater.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import Combine

protocol ExternalGoalServiceBridge {
    func allowsAccess() -> Bool
    func getReminder(for id: String) -> NSObject?
    func complete(_ object: NSObject)
}

final class ExternalGoalServiceUpdater {
    
    let bridge: ExternalGoalServiceBridge
    
    var subscriptions = Set<AnyCancellable>()
    
    init(bridge: ExternalGoalServiceBridge) {
        self.bridge = bridge
        
        NotificationCenter.default.publisher(for: Plan.GoalWasCompleted).sink(receiveValue: goalWasCompleted)
            .store(in: &subscriptions)
    }
    
    private func goalWasCompleted(_ notification: Notification) {
        
        guard bridge.allowsAccess(),
              let id = notification.userInfo?[Plan.GoalIDKey] as? String,
              let reminder = bridge.getReminder(for: id) else { return }
        
        bridge.complete(reminder)
    }
    
}
