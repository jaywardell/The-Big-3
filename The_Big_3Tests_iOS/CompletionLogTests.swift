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
    
    func test_init_calls_loadDDates_from_archive() {
        let archive = CompletionLogArchiveSpy()
        _ = makeSUT(archive: archive)
        
        XCTAssertEqual(archive.loadCount, 1)
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
    
    func test_dates_isEmpty_on_init() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.dates, [])
    }
    
    func test_dates_is_updated_by_log() throws {
        var sut = makeSUT()
        let finished = finishedGoal
        let date = Date()
        
        try sut.log(finished, date: date)
        
        XCTAssert(sut.dates.contains(date))
    }
    
    func test_dates_returns_goals_sorted_by_date_regardless_of_order_goals_were_logged() throws {
        var sut = makeSUT()
        
        let goal1 = Plan.Goal(title: "1", state: .completed)
        let goal2 = Plan.Goal(title: "2", state: .completed)
        let goal3 = Plan.Goal(title: "3", state: .completed)
        
        let date1 = Date()
        let date2 = Date().addingTimeInterval(1)
        let date3 = Date().addingTimeInterval(2)
        
        // log them intentionally out of order
        try sut.log(goal1, date: date1)
        try sut.log(goal3, date: date3)
        try sut.log(goal2, date: date2)
        
        XCTAssertEqual(sut.dates, [date1, date2, date3])
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
    
    func test_titleForGoal_properly_returns_goal_for_date_regardless_of_order_logged() throws {
        var sut = makeSUT()
        
        let goal1 = Plan.Goal(title: "1", state: .completed)
        let goal2 = Plan.Goal(title: "2", state: .completed)
        let goal3 = Plan.Goal(title: "3", state: .completed)
        
        let date1 = Date()
        let date2 = Date().addingTimeInterval(1)
        let date3 = Date().addingTimeInterval(2)
        
        // log them intentionally out of order
        try sut.log(goal1, date: date1)
        try sut.log(goal3, date: date3)
        try sut.log(goal2, date: date2)
        
        XCTAssertEqual(sut.titleForGoal(completedAt: date1), goal1.title)
        XCTAssertEqual(sut.titleForGoal(completedAt: date2), goal2.title)
        XCTAssertEqual(sut.titleForGoal(completedAt: date3), goal3.title)
    }
    
    // METHOD: - Helpers
    
    private func makeSUT(archive: CompletionLogArchive? = nil) -> CompletionLog {
        CompletionLog(archive: archive ?? CompletionLogArchiveSpy())
    }
    
    private var pendingGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .pending) }
    private var deferredGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .deferred) }
    private var finishedGoal: Plan.Goal { Plan.Goal(title: "finished", state: .completed) }
    
    final class CompletionLogArchiveSpy: CompletionLogArchive {
        
        private(set) var loadCount = 0
        
        func load() -> [Date: String] {
            loadCount += 1
            return [:]
        }
    }
}

