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
