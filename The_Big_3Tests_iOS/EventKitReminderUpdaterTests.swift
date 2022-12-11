//
//  EventKitReminderUpdaterTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 12/10/22.
//

import XCTest

@testable
import The_Big_3

final class EventKitReminderUpdaterTests: XCTestCase {

    func test_asks_bridge_for_reminder_when_receiving_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = EventKitReminderUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: ""])
        
        XCTAssertEqual(spy.getRemidnerCount, 1)
    }
    
    func test_passes_id_to_bridge_when_receiving_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = EventKitReminderUpdater(bridge: spy)
        
        let expected = UUID().uuidString
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: expected])
        
        XCTAssertEqual(spy.lastIDRequested, expected)
    }

    // MARK: - Helpers
    
    final class EventKitReminderBridgeSpy: EventKitReminderBridge {
        
        private(set) var getRemidnerCount = 0
        private(set) var lastIDRequested: String?

        func getReminder(for id: String) {
            getRemidnerCount += 1
            lastIDRequested = id
        }
        
        
    }
}
