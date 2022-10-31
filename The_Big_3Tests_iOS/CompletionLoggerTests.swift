//
//  CompletionLoggerTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 10/31/22.
//

import XCTest

@testable
import The_Big_3

final class CompletionLoggerTests: XCTestCase {
    
    func test_dates_isEmpty_on_init() {
        let sut = CompletionLog()
        
        XCTAssertEqual(sut.dates, [])
    }
    
    func test_log_throws_if_goal_is_pending() {
        let sut = CompletionLog()
        
        let unfinished = Plan.Goal(title: "unfinished", state: .pending)
        
        XCTAssertThrowsError(try sut.log(unfinished)) { error in
            XCTAssertEqual(error as? CompletionLog.Error, .GoalIsNotCompleted)
        }
    }

    func test_log_throws_if_goal_is_deferred() {
        let sut = CompletionLog()
        
        let unfinished = Plan.Goal(title: "unfinished", state: .deferred)
        
        XCTAssertThrowsError(try sut.log(unfinished)) { error in
            XCTAssertEqual(error as? CompletionLog.Error, .GoalIsNotCompleted)
        }
    }

    func test_log_does_not_throw_if_goal_is_completed() throws {
        let sut = CompletionLog()
        
        let finished = Plan.Goal(title: "finisjed", state: .completed)
        
        XCTAssertNoThrow(try sut.log(finished))
    }
}
