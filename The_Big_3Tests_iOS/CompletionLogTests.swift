//
//  CompletionLogTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 10/31/22.
//

import XCTest
import Combine

@testable
import The_Big_3

final class CompletionLogTests: XCTestCase {
        
    func test_init_does_not_access_archive() {
        let archive = CompletionLogArchiveSpy()
        _ = makeSUT(archive: archive)
        
        XCTAssertEqual(archive.loadCount, 0)
    }
    
    // MARK: - loadArchive
    
    func test_loadArchive_takes_days_from_archive() async throws {
        let date1 = Date()
        let date2 = Date().addingTimeInterval(25*3660)
        let date3 = Date().addingTimeInterval(25*3660 + 1)
        let archive = CompletionLogArchiveSpy(exampleDate: [
            date1: "example1",
            date2: "example2",
            date3: "example3"
        ])
        let sut = makeSUT(archive: archive)
        await sut.loadArchive()
        
        let expected = [
            Calendar.current.startOfDay(for: date1),
            Calendar.current.startOfDay(for: date2)
            // date3 is on the same day as date2,
            // so it shouldn't show up
        ]

        XCTAssertEqual(sut.days, expected)
    }
    
    func test_loadArchive_takes_goal_titles_from_archive() async throws {
        let expectedDate = Date()
        let expectedTitle = "goal"
        let archive = CompletionLogArchiveSpy(exampleDate: [
            expectedDate: expectedTitle,
        ])
        let sut = makeSUT(archive: archive)
        await sut.loadArchive()
        
        XCTAssertEqual(sut.titleForGoal(completedAt: expectedDate), expectedTitle)
    }

    func test_loadArchive_calls_loadDDates_from_archive() async {
        let archive = CompletionLogArchiveSpy()
        let sut = makeSUT(archive: archive)
        
        await sut.loadArchive()
        
        XCTAssertEqual(archive.loadCount, 1)
    }
    
    // MARK: - log
    
    func test_log_throws_if_goal_is_pending() async {
        let sut = makeSUT()
        
        await expect(CompletionLog.Error.GoalIsNotCompleted) {
            try await sut.log(pendingGoal)
        }
    }
    
    func test_log_throws_if_goal_is_deferred() async {
        let sut = makeSUT()
        
        await expect(CompletionLog.Error.GoalIsNotCompleted) {
            try await sut.log(deferredGoal)
        }
    }
    
    func test_log_does_not_throw_if_goal_is_completed() async throws {
        let sut = makeSUT()
        
        await expectNoError {
            try await sut.log(finishedGoal)
        }
    }
    
    func test_log_updates_days() async throws {
        let sut = makeSUT()
        
        let date = Date()
        let expected = [Calendar.current.startOfDay(for: date)]
        
        try await sut.log(finishedGoal, date: date)
        
        XCTAssertEqual(sut.days, expected)
    }
    
    func test_log_updates_timeForGoals() async throws {
        let sut = makeSUT()
        
        let date = Date()
        let day = Calendar.current.startOfDay(for: date)
        let expected = [date]
        
        try await sut.log(finishedGoal, date: date)
        
        XCTAssertEqual(sut.timesForGoals(completedOn: day), expected)
    }

    func test_log_updates_titleForGoal() async throws {
        let sut = makeSUT()
        
        let date = Date()
        let tolog = finishedGoal
        let expected = tolog.title
        
        try await sut.log(tolog, date: date)
        
        XCTAssertEqual(sut.titleForGoal(completedAt: date), expected)
    }

    func test_log_calls_archive_record() async throws {
        let spy = CompletionLogArchiveSpy()
        let sut = makeSUT(archive: spy)
        
        try await sut.log(finishedGoal)
        
        XCTAssertEqual(spy.recordCount, 1)
    }
    
    func test_log_passes_proper_title_to_record() async throws {
        let spy = CompletionLogArchiveSpy()
        let sut = makeSUT(archive: spy)
        
        let toadd = finishedGoal
        let expected = toadd.title
        
        try await sut.log(finishedGoal)
        
        XCTAssertEqual(spy.lastRecordedTitle, expected)
    }

    func test_log_passes_proper_date_to_record() async throws {
        let spy = CompletionLogArchiveSpy()
        let sut = makeSUT(archive: spy)
        
        let expected = Date().addingTimeInterval(5)
        
        try await sut.log(finishedGoal, date: expected)
        
        XCTAssertEqual(spy.lastRecordedDate, expected)
    }

    func test_log_triggers_publisher() async throws {
        let sut = makeSUT()

        try await expectChanges(for: sut.logChanged.eraseToAnyPublisher(), count: 1) {
            try await sut.log(finishedGoal)
        }
    }
    
    func test_log_sends_new_days_to_publisher() async throws {
        let sut = makeSUT()

        var found = [Date]()

        let expectation = XCTestExpectation(description: "log publishes changes")
        var cancellables = Set<AnyCancellable>()
        sut.logChanged.sink {
            found = $0
            expectation.fulfill()
        }
        .store(in: &cancellables)
        try await sut.log(finishedGoal)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(sut.days, found)
    }
    
    func test_log_sends_new_days_to_publisher_even_if_day_is_already_logged_for_another_goal() async throws {
        let sut = makeSUT()
        try await sut.log(finishedGoal2)
        
        var found = [Date]()

        let expectation = XCTestExpectation(description: "log publishes changes")
        var cancellables = Set<AnyCancellable>()
        sut.logChanged.sink {
            found = $0
            expectation.fulfill()
        }
        .store(in: &cancellables)
        try await sut.log(finishedGoal)
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(sut.days, found)
    }

    // MARK: - days
    
    func test_days_is_impty_on_init() {
        let sut = makeSUT()
        
        XCTAssert(sut.days.isEmpty)
    }
    
    func test_days_is_updated_by_log() async throws {
        let sut = makeSUT()
        let date = Date()
        let expected = Calendar.current.startOfDay(for: date)
        
        try await sut.log(finishedGoal, date: date)
        
        XCTAssert(sut.days.contains(expected))
    }

    func test_days_is_not_updated_if_another_goal_was_recorded_on_the_same_day() async throws {
        let sut = makeSUT()
        let date1 = Date()
        let date2 = Date().addingTimeInterval(1)
        let expected = [Calendar.current.startOfDay(for: date1)]

        try await sut.log(finishedGoal, date: date1)
        try await sut.log(finishedGoal2, date: date2)
        
        XCTAssertEqual(sut.days, expected)
    }

    func test_days_is_updated_if_recorded_on_a_new_day() async throws {
        let sut = makeSUT()
        let date1 = Date()
        let date2 = Date().addingTimeInterval(25*(3600))
        let expected = [
            Calendar.current.startOfDay(for: date1),
            Calendar.current.startOfDay(for: date2)
        ]

        try await sut.log(finishedGoal, date: date1)
        try await sut.log(finishedGoal2, date: date2)
        
        XCTAssertEqual(sut.days, expected)
    }

    // MARK: - titleForGoal
    
    func test_titleForGoal_returns_nil_if_no_matching_goal_has_been_logged() {
        let sut = makeSUT()
        
        XCTAssertNil(sut.titleForGoal(completedAt: Date()))
    }
    
    func test_titleForGoal_return_title_of_goal_logged_for_fate_it_was_logged() async throws {
        let sut = makeSUT()
        let toLog = finishedGoal
        let date = Date()
        
        try await sut.log(toLog, date: date)
        
        XCTAssertEqual(sut.titleForGoal(completedAt: date), toLog.title)
    }
    
    func test_titleForGoal_properly_returns_goal_for_date_regardless_of_order_logged() async throws {
        let sut = makeSUT()
        
        let goal1 = Plan.Goal(title: "1", state: .completed)
        let goal2 = Plan.Goal(title: "2", state: .completed)
        let goal3 = Plan.Goal(title: "3", state: .completed)
        
        let date1 = Date()
        let date2 = Date().addingTimeInterval(1)
        let date3 = Date().addingTimeInterval(2)
        
        // log them intentionally out of order
        try await sut.log(goal1, date: date1)
        try await sut.log(goal3, date: date3)
        try await sut.log(goal2, date: date2)
        
        XCTAssertEqual(sut.titleForGoal(completedAt: date1), goal1.title)
        XCTAssertEqual(sut.titleForGoal(completedAt: date2), goal2.title)
        XCTAssertEqual(sut.titleForGoal(completedAt: date3), goal3.title)
    }
    
    // MARK: - timesForGoals
    
    func test_timesForGoals_returns_empty_if_no_goals_logged() {
        let sut = makeSUT()
        
        XCTAssert(sut.timesForGoals(completedOn: Date()).isEmpty)
    }
    
    func test_timesForGoals_returns_empty_if_no_dates_on_the_day_passed_in() throws {
        
        let date = Date().addingTimeInterval(24*3600)
        let archive = CompletionLogArchiveSpy(exampleDate: [
            date: "example1"
        ])
        let sut = makeSUT(archive: archive)

        XCTAssert(sut.timesForGoals(completedOn: Date()).isEmpty)
    }
    
    func test_timesForGoals_returns_dates_matching_day_passed_in() async throws {
        
        let date1 = Date().addingTimeInterval(1)
        let date2 = Date().addingTimeInterval(2)
        let archive = CompletionLogArchiveSpy(exampleDate: [
            date1: "example1",
            date2: "example2"
        ])
        let sut = makeSUT(archive: archive)
        await sut.loadArchive()

        let expected = [date1, date2]
        
        XCTAssertEqual(sut.timesForGoals(completedOn: Date()), expected)
    }

    func test_timesForGoals_returns_dates_in_order_regardless_of_when_they_were_logged() async throws {
        
        let date1 = Date().addingTimeInterval(1)
        let date2 = Date().addingTimeInterval(2)
        let sut = makeSUT()

        let expected = [date1, date2]
        
        try await sut.log(finishedGoal2, date: date2)
        try await sut.log(finishedGoal, date: date1)
        
        XCTAssertEqual(sut.timesForGoals(completedOn: Date()), expected)
    }

    // edge case
    func test_timesForGoals_returns_start_of_day_if_its_logged_and_passed_in() async throws {
        
        let date = Calendar.current.startOfDay(for: Date())
        let archive = CompletionLogArchiveSpy(exampleDate: [
            date: "example1"
        ])
        let sut = makeSUT(archive: archive)
        await sut.loadArchive()

        let expected = [date]
        
        XCTAssertEqual(sut.timesForGoals(completedOn: date), expected)
    }

    // MARK: - Helpers
    
    private func makeSUT(archive: CompletionLogArchive? = nil) -> CompletionLog {
        CompletionLog(archive: archive ?? CompletionLogArchiveSpy())
    }
    
    private var pendingGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .pending) }
    private var deferredGoal: Plan.Goal { Plan.Goal(title: "unfinished", state: .deferred) }
    private var finishedGoal: Plan.Goal { Plan.Goal(title: "finished", state: .completed) }
    private var finishedGoal2: Plan.Goal { Plan.Goal(title: "finished 2", state: .completed) }

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
    
    func expect<E: Error>(_ expectedError: E, when callback: () async throws -> (), file: StaticString = #filePath, line: UInt = #line) async where E: Equatable {
        do {
            _ = try await callback()
            XCTFail("Expected to throw error while awaiting, but succeeded", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? E, expectedError, "expected \(expectedError) but got \(error)", file: file, line: line)
        }
    }

    func expectNoError(_ callback: () async throws -> (), file: StaticString = #filePath, line: UInt = #line) async {
        do {
            _ = try await callback()
        } catch {
            XCTFail("Expected to not throw an error, but thres \(error)", file: file, line: line)
        }
    }

}

