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

    func test_asks_for_reminder_by_id_when_receiving_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = EventKitReminderUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil)
        
        XCTAssertEqual(spy.getRemidnerCount, 1)
    }
    
    // MARK: - Helpers
    
    final class EventKitReminderBridgeSpy: EventKitReminderBridge {
        
        private(set) var getRemidnerCount = 0
        
        func getReminder(for id: String) {
            getRemidnerCount += 1
        }
        
        
    }
}
