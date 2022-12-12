//
//  ExternalGoalServiceUpdaterTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 12/10/22.
//

import XCTest

@testable
import The_Big_3

final class ExternalGoalServiceUpdaterTests: XCTestCase {

    func test_does_not_ask_bridge_for_reminder_if_user_access_denied() {
        let spy = EventKitReminderBridgeSpy(userCanAccess: false)
        _ = ExternalGoalServiceUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: ""])
        
        XCTAssertEqual(spy.getRemidnerCount, 0)

    }
    
    func test_asks_bridge_for_reminder_when_receiving_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = ExternalGoalServiceUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: ""])
        
        XCTAssertEqual(spy.getRemidnerCount, 1)
    }
    
    func test_passes_id_to_bridge_when_receiving_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = ExternalGoalServiceUpdater(bridge: spy)
        
        let expected = UUID().uuidString
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: expected])
        
        XCTAssertEqual(spy.lastIDRequested, expected)
    }

    func test_does_not_call_complete_when_no_id_in_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = ExternalGoalServiceUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil)
        
        XCTAssertEqual(spy.completeCount, 0)
    }
    
    func test_calls_complete_when_a_valid_id_is_in_notification() {
        let spy = EventKitReminderBridgeSpy()
        _ = ExternalGoalServiceUpdater(bridge: spy)
        
        NotificationCenter.default.post(name: Plan.GoalWasCompleted, object: nil, userInfo: [Plan.GoalIDKey: UUID().uuidString])
        
        XCTAssertEqual(spy.completeCount, 1)
    }

    // MARK: - Helpers
    
    final class EventKitReminderBridgeSpy: ExternalGoalServiceBridge {
        
        let userCanAccess: Bool
        
        private(set) var getRemidnerCount = 0
        private(set) var lastIDRequested: String?

        private(set) var completeCount = 0
        
        init(userCanAccess: Bool = true) {
            self.userCanAccess = userCanAccess
        }
        
        func allowsAccess() -> Bool {
            userCanAccess
        }

        func getReminder(for id: String) -> NSObject? {
            getRemidnerCount += 1
            lastIDRequested = id
            
            return NSString()
        }
        
        func complete(_ object: NSObject) {
            completeCount += 1
        }
    }
}
