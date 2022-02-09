//
//  PlanTests.swift
//  ModelTestsMacOS
//
//  Created by Joseph Wardell on 2/8/22.
//

import XCTest

@testable
import The_Big_3

class PlanTests: XCTestCase {

    func test_goals_is_empty_on_init() {
        let sut = Plan()
        
        XCTAssert(sut.goals.isEmpty)
    }
    
    func test_allowed_is_take_from_init() {
        let expected = 12
        let sut = Plan(allowed: expected)
        
        XCTAssertEqual(sut.allowed, expected)
    }
    
    func test_goal_at_returns_nil_if_no_goal_is_set() throws {
        let sut = Plan(allowed: 1)
        
        XCTAssertNil(try sut.goal(at: 0))
    }
    
    func test_goal_at_throws_if_index_is_above_allowed() {
        let sut = Plan()
        
        expect(.indexExceedsAllowed) {
            try sut.goal(at: Int.max)
        }
    }
    
    func test_set_goal_at_throws_if_index_is_above_allowed() {
        let sut = Plan()
        
        expect(.indexExceedsAllowed) {
            try sut.set(exampleGoal, at: Int.max)
        }
    }
    
    func test_set_goal_at_sets_the_goal_at_the_index_to_the_goal_passed_in() throws {
        let sut = Plan(allowed: 1)
        let expected = exampleGoal
        
        try sut.set(expected, at: 0)
        XCTAssertEqual(try sut.goal(at: 0), expected)
    }
    
    func test_set_goal_at_throws_if_a_goal_already_exists_at_the_index_passed_in() throws {
        let sut = Plan(allowed: 1)
        let expected = exampleGoal
        
        try sut.set(expected, at: 0)

        expect(.goalExistsAtIndex) {
            try sut.set(expected, at: 0)
        }
    }
    
    func test_remove_at_throws_if_index_is_not_allowed() {
        let sut = Plan()
        
        expect(.indexExceedsAllowed) {
            try sut.remove(at: 0)
        }
    }
    
    func test_remove_at_throws_if_no_goal_exists_at_index() {
        let sut = Plan(allowed: 1)
        
        expect(.noGoalExistsAtIndex) {
            try sut.remove(at: 0)
        }
    }

    func test_remove_at_removes_goal_at_index() throws {
        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)
        
        try sut.remove(at: 0)
        
        XCTAssertNil(try sut.goal(at:0))
    }

    func test_isEmpty_is_true_on_init() {
        let sut = Plan(allowed: 1)
        
        XCTAssert(sut.isEmpty)
    }
    
    func test_isEmpty_is_false_if_any_goals_are_set() throws {
        let sut = Plan(allowed: 10)
        
        for i in 0...9 {
            try sut.set(exampleGoal, at: i)
            XCTAssertFalse(sut.isEmpty)
            try sut.remove(at: i)
        }
    }

    func test_isFull_is_false_on_init() {
        let sut = Plan(allowed: 1)
        
        XCTAssertFalse(sut.isFull)
    }

    
    
    // MARK: - Helpers
    
    private var exampleGoal: String { "a goal" }
    
    private func expect(_ expectedError: Plan.Error, when callback: () throws -> (), file: StaticString = #filePath, line: UInt = #line) {

        XCTAssertThrowsError(try callback()) { error in
            switch error as? Plan.Error {
            case expectedError:
                break
            default:
                XCTFail()
            }
        }
    }
    
}
