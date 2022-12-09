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
    
    func test_init_takes_dates_from_archive() throws {
        let archive = CompletionLogArchiveSpy(exampleDate: [
            Date().addingTimeInterval(1): "example1",
            Date().addingTimeInterval(2): "example2"
        ])
        let sut = makeSUT(archive: archive)

        XCTAssertEqual(Set(sut.dates), Set(archive.exampleData.keys))
    }
    
    func test_init_takes_goal_titles_from_archive() throws {
        let expectedDate = Date()
        let expectedTitle = "goal"
        let archive = CompletionLogArchiveSpy(exampleDate: [
            expectedDate: expectedTitle,
        ])
        let sut = makeSUT(archive: archive)

        XCTAssertEqual(sut.titleForGoal(completedAt: expectedDate), expectedTitle)
    }

    func test_init_ensures_dates_are_sorted() throws {
        let date1 = Date().addingTimeInterval(1)
        let date2 = Date().addingTimeInterval(2)
        let date3 = Date().addingTimeInterval(3)
        let date4 = Date().addingTimeInterval(4)
        let expectedOrder = [date1, date2, date3, date4]
        let archive = CompletionLogArchiveSpy(exampleDate: [
            date1: "example1",
            date2: "example2",
            date3: "example1",
            date4: "example2"
        ])
        let sut = makeSUT(archive: archive)

        XCTAssertEqual(sut.dates, expectedOrder)
    }

    func test_init_calls_loadDDates_from_archive() {
        let archive = CompletionLogArchiveSpy()
        _ = makeSUT(archive: archive)
        
        XCTAssertEqual(archive.loadCount, 1)
    }
    
    // MARK: - log
    
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
    
    func test_log_calls_archive_record() throws {
        let spy = CompletionLogArchiveSpy()
        var sut = makeSUT(archive: spy)
        
        try sut.log(finishedGoal)
        
        XCTAssertEqual(spy.recordCount, 1)
    }
    
    func test_log_passes_proper_title_to_record() throws {
        let spy = CompletionLogArchiveSpy()
        var sut = makeSUT(archive: spy)
        
        let toadd = finishedGoal
        let expected = toadd.title
        
        try sut.log(finishedGoal)
        
        XCTAssertEqual(spy.lastRecordedTitle, expected)
    }

    func test_log_passes_proper_date_to_record() throws {
        let spy = CompletionLogArchiveSpy()
        var sut = makeSUT(archive: spy)
        
        let expected = Date().addingTimeInterval(5)
        
        try sut.log(finishedGoal, date: expected)
        
        XCTAssertEqual(spy.lastRecordedDate, expected)
    }

    // MARK: - days
    
    func test_days_is_impty_on_init() {
        let sut = makeSUT()
        
        XCTAssert(sut.days.isEmpty)
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
    
    // MARK: - Helpers
    
    private func makeSUT(archive: CompletionLogArchive? = nil) -> CompletionLog {
        CompletionLog(archive: archive ?? CompletionLogArchiveSpy())
    }
    
    private var pendingGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .pending) }
    private var deferredGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .deferred) }
    private var finishedGoal: Plan.Goal { Plan.Goal(title: "finished", state: .completed) }
    
    final class CompletionLogArchiveSpy: CompletionLogArchive {
        
        let exampleData: [Date:String]
        
        private(set) var loadCount = 0
        private(set) var lastRecordedTitle: String?
        private(set) var lastRecordedDate: Date?
        private(set) var recordCount = 0

        init(exampleDate: [Date:String] = [:]) {
            self.exampleData = exampleDate
        }
        
        func load() -> [Date: String] {
            loadCount += 1
            return exampleData
        }
        
        func record(_ string: String, at date: Date) {
            recordCount += 1
            lastRecordedDate = date
            lastRecordedTitle = string
        }
    }
}

