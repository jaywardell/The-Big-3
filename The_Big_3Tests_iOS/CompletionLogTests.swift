//
//  CompletionLogTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 10/31/22.
//

import XCTest

@testable
import The_Big_3

final class CompletionLogTests: XCTestCase {
    
    func test_dates_isEmpty_on_init() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.dates, [])
    }
    
    func test_log_throws_if_goal_is_pending() {
        var sut = makeSUT()
                
        XCTAssertThrowsError(try sut.log(pendingGoal)) { error in
            XCTAssertEqual(error as? CompletionLog.Error, .GoalIsNotCompleted)
        }
    }

    func test_log_throws_if_goal_is_deferred() {
        var sut = makeSUT()
                
        XCTAssertThrowsError(try sut.log(deferredGoal)) { error in
            XCTAssertEqual(error as? CompletionLog.Error, .GoalIsNotCompleted)
        }
    }

    func test_log_does_not_throw_if_goal_is_completed() throws {
        var sut = makeSUT()
                
        XCTAssertNoThrow(try sut.log(finishedGoal))
    }
    
    // MARK: - dates
    
    func test_dates_is_updated_by_log() throws {
        var sut = makeSUT()
        let finished = finishedGoal
        let date = Date()

        try sut.log(finished, date: date)
        
        XCTAssert(sut.dates.contains(date))
    }
    
    // MARK: - titleForGoal
    
    func test_titleForGoal_returns_nil_if_no_matching_goal_has_been_logged() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.titleForGoal(completedAt: Date()))
    }
    
    func test_titleForGoal_return_title_of_goal_logged_for_fate_it_was_logged() throws {
        var sut = makeSUT()
        let toLog = finishedGoal
        let date = Date()
        
        try sut.log(toLog, date: date)
        
        XCTAssertEqual(sut.titleForGoal(completedAt: date), toLog.title)
    }
    
    // METHOD: - Helpers
    
    private func makeSUT() -> CompletionLog {
        CompletionLog()
    }
    
    private var pendingGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .pending) }
    private var deferredGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .deferred) }
    private var finishedGoal: Plan.Goal { Plan.Goal(title: "finished", state: .completed) }
}
