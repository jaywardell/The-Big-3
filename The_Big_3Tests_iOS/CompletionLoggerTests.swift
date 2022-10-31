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
    
    func test_log_throws_if_goal_not_completed() {
        let sut = CompletionLog()
        
        let unfinished = Plan.Goal(title: "unfinished", state: .pending)
        
        XCTAssertThrowsError(try sut.log(unfinished)) { error in
            XCTAssertEqual(error as? CompletionLog.Error, .GoalIsNotCompleted)
        }
    }
    
}
