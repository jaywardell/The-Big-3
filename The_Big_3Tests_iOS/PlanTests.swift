//
//  PlanTests.swift
//  ModelTestsMacOS
//
//  Created by Joseph Wardell on 2/8/22.
//

import XCTest
import Combine

@testable
import The_Big_3

class PlanTests: XCTestCase {
    
    func test_allowed_is_taken_from_init() {
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
    
    func test_goal_at_does_not_send_from_publisher() throws {
        let sut = Plan(allowed: 1)
        let expected = exampleGoal
        
        try sut.set(expected, at: 0)
        
        try expectNoChanges(on: sut) {
            try sut.goal(at: 0)
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
        XCTAssertEqual(try sut.goal(at: 0)?.title, expected)
    }
    
    func test_set_goal_at_sends_from_publisher() throws {
        let sut = Plan(allowed: 1)

        try expectChanges(on: sut, count: 1) {
            try sut.set(exampleGoal, at: 0)
        }
    }
    

    func test_set_goal_at_throws_if_a_goal_already_exists_at_the_index_passed_in() throws {
        let sut = Plan(allowed: 1)
        let expected = exampleGoal
        
        try sut.set(expected, at: 0)

        expect(.goalExistsAtIndex) {
            try sut.set(expected, at: 0)
        }
    }
    
    func test_set_goal_at_throws_if_goal_already_exists_in_plan() throws {
        
        let sut = Plan(allowed: 2)
        let expected = exampleGoal
        
        try sut.set(expected, at: 0)

        expect(.goalIsAlreadyInPlan) {
            try sut.set(expected, at: 1)
        }
    }
    
    func test_removeGoal_at_throws_if_index_is_not_allowed() {
        let sut = Plan()
        
        expect(.indexExceedsAllowed) {
            try sut.removeGoal(at: 0)
        }
    }
    
    func test_removeGoal_at_throws_if_no_goal_exists_at_index() {
        let sut = Plan(allowed: 1)
        
        expect(.noGoalExistsAtIndex) {
            try sut.removeGoal(at: 0)
        }
    }

    func test_removeGoal_at_removes_goal_at_index() throws {
        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)
        
        try sut.removeGoal(at: 0)
        
        XCTAssertNil(try sut.goal(at:0))
    }

    func test_removeGoal_at_sends_from_publisher() throws {
        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)

        try expectChanges(on: sut, count: 1) {
            try sut.removeGoal(at: 0)
        }
    }

    func test_isEmpty_is_true_on_init() {
        let sut = Plan(allowed: 1)
        
        XCTAssert(sut.isEmpty)
    }
    
    func test_isEmpty_is_false_if_any_goals_are_set() throws {
        let sut = Plan(allowed: 10)
        
        try sut.set(exampleGoal, at: 0)
        XCTAssertFalse(sut.isEmpty)
    }

    func test_isFull_is_false_on_init() {
        let sut = Plan(allowed: 1)
        
        XCTAssertFalse(sut.isFull)
    }

    func test_isFull_is_false_if_any_goals_are_set() throws {
        let sut = Plan(allowed: 10)
        
        for i in 0...8 {
            try sut.set(String(i), at: i)
            XCTAssertFalse(sut.isFull)
        }
    }

    func test_isFull_is_true_if_all_goals_are_set() throws {
        let sut = Plan(allowed: 10)
        
        for i in 0...9 {
            try sut.set(String(i), at: i)
        }
        XCTAssertTrue(sut.isFull)
    }
    
    func test_set_goal_at_index_sets_goal_state_to_pending() throws {
        let sut = Plan(allowed: 1)

        try sut.set(exampleGoal, at: 0)

        XCTAssertEqual(try sut.goal(at: 0)?.state, .pending)
    }
  
    func test_defer_goal_at_index_throws_if_index_is_not_allowed() {
        let sut = Plan()
        
        expect(.indexExceedsAllowed) {
            try sut.deferGoal(at: 0)
        }
    }
    
    func test_defer_goal_at_index_throws_if_no_goal_at_index() {
        let sut = Plan(allowed: 1)
        
        expect(.noGoalExistsAtIndex) {
            try sut.deferGoal(at: 0)
        }
    }

    func test_defer_goal_at_index_changes_result_of_state_for_goal_at_index_to_deferred() throws {

        let sut = Plan(allowed: 1)

        try sut.set(exampleGoal, at: 0)
        try sut.deferGoal(at: 0)

        XCTAssertEqual(try sut.goal(at: 0)?.state, .deferred)
    }
    
    func test_defer_goal_at_index_sends_from_publisher() throws {
        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)

        try expectChanges(on: sut, count: 1) {
            try sut.deferGoal(at: 0)
        }
    }

    
    func test_defer_goal_at_index_throws_if_goal_is_already_deferred() throws {

        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)
        try sut.deferGoal(at: 0)

        expect(.goalIsAlreadyDeferred) {
            try sut.deferGoal(at: 0)
        }
    }

    func test_defer_goal_at_index_throws_if_goal_is_already_completed() throws {

        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)
        try sut.completeGoal(at: 0)

        expect(.goalIsAlreadyCompleted) {
            try sut.deferGoal(at: 0)
        }
    }

    func test_complete_goal_at_index_throws_if_index_is_not_allowed() {
        let sut = Plan()

        expect(.indexExceedsAllowed) {
            try sut.completeGoal(at: 0)
        }
    }

    func test_complete_goal_at_index_throws_if_no_goal_at_index() {
        let sut = Plan(allowed: 1)

        expect(.noGoalExistsAtIndex) {
            try sut.completeGoal(at: 0)
        }
    }

    func test_complete_goal_at_index_changes_result_of_state_for_goal_at_index_to_completed() throws {

        let sut = Plan(allowed: 1)

        try sut.set(exampleGoal, at: 0)
        try sut.completeGoal(at: 0)

        XCTAssertEqual(try sut.goal(at: 0)?.state, .completed)
    }

    func test_complete_goal_at_index_sends_from_publisher() throws {
        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)

        try expectChanges(on: sut, count: 1) {
            try sut.completeGoal(at: 0)
        }
    }

    func test_complete_goal_at_index_throws_if_goal_is_already_completed() throws {

        let sut = Plan(allowed: 1)
        try sut.set(exampleGoal, at: 0)
        try sut.completeGoal(at: 0)

        expect(.goalIsAlreadyCompleted) {
            try sut.completeGoal(at: 0)
        }
    }

    func test_complete_goal_at_index_changes_result_of_state_for_goal_at_index_to_completed_if_goal_was_already_deferred() throws {

        let sut = Plan(allowed: 1)

        try sut.set(exampleGoal, at: 0)
        try sut.deferGoal(at: 0)

        try sut.completeGoal(at: 0)

        XCTAssertEqual(try sut.goal(at: 0)?.state, .completed)
    }

    func test_isComplete_returns_false_on_init() {
        let sut = Plan(allowed: 1)
        
        XCTAssertFalse(sut.isComplete)
    }
    
    func test_isComplete_returns_false_if_some_goals_are_pending() throws {
        let sut = Plan(allowed: 2)
        
        try sut.set(exampleGoal, at: 0)
        XCTAssertFalse(sut.isComplete)
        
        try sut.set(exampleGoal2, at: 1)
        XCTAssertFalse(sut.isComplete)
        
        try sut.completeGoal(at: 0)
        XCTAssertFalse(sut.isComplete)
    }
    
    func test_isComplete_returns_true_if_all_goals_are_completed() throws {
        let sut = Plan(allowed: 2)
        
        try sut.set(exampleGoal, at: 0)
        try sut.set(exampleGoal2, at: 1)
        
        try sut.completeGoal(at: 0)
        try sut.completeGoal(at: 1)
        
        XCTAssert(sut.isComplete)
    }
    
    func test_isComplete_returns_true_if_all_goals_are_deferred() throws {
        let sut = Plan(allowed: 2)
        
        try sut.set(exampleGoal, at: 0)
        try sut.set(exampleGoal2, at: 1)
        
        try sut.deferGoal(at: 0)
        try sut.deferGoal(at: 1)
        
        XCTAssert(sut.isComplete)
    }

    func test_isComplete_returns_true_if_some_goals_are_completed_and_others_are_deferred_as_long_as_none_are_pending() throws {
        let sut = Plan(allowed: 2)
        
        try sut.set(exampleGoal, at: 0)
        try sut.set(exampleGoal2, at: 1)
        
        try sut.completeGoal(at: 0)
        try sut.deferGoal(at: 1)
        
        XCTAssert(sut.isComplete)
    }

    func test_remanant_throws_if_not_complete() throws {
        let sut = Plan(allowed: 1)

        expect(.notComplete) {
            _ = try sut.remnant()
        }
    }
    
    func test_remanant_returns_empty_plan_if_all_goals_are_complete() throws {
        let sut = Plan(allowed: 1)
        
        try sut.set(exampleGoal, at: 0)
        
        try sut.completeGoal(at: 0)

        let remnant = try sut.remnant()
        
        XCTAssertEqual(remnant.allowed, sut.allowed)
        XCTAssertNil(try remnant.goal(at:0))
    }
    
    func test_remanant_returns_nonempty_plan_if_any_goals_are_deferred() throws {
        let sut = Plan(allowed: 1)
        
        try sut.set(exampleGoal, at: 0)
        
        try sut.deferGoal(at: 0)

        let remnant = try sut.remnant()
        
        XCTAssertEqual(remnant.allowed, sut.allowed)
        XCTAssertEqual(try sut.goal(at: 0)?.title, try remnant.goal(at: 0)?.title)
        XCTAssertEqual(.pending, try remnant.goal(at: 0)?.state)
    }

    func test_remanant_against_complex_example() throws {
        let sut = Plan(allowed: 2)
        
        try sut.set(exampleGoal, at: 0)
        try sut.set(exampleGoal2, at: 1)

        try sut.completeGoal(at: 0)
        try sut.deferGoal(at: 1)

        let remnant = try sut.remnant()
        
        XCTAssertEqual(remnant.allowed, sut.allowed)
        XCTAssertNil(try remnant.goal(at:0))
        XCTAssertEqual(try sut.goal(at: 1)?.title, try remnant.goal(at: 1)?.title)
        XCTAssertEqual(.pending, try remnant.goal(at: 1)?.state)
    }

    func test_remnant_stress_test() throws {
        var sut = Plan(allowed: 4)
        
        for _ in 0..<100 {
            for i in 0..<sut.allowed {
                let existing = try sut.goal(at: i)
                if nil == existing {
                    try sut.set(String(i), at: i)
                }
            }
            
            for i in 0..<sut.allowed {
                if Bool.random() {
                    try sut.completeGoal(at: i)
                }
                else {
                    try sut.deferGoal(at: i)
                }
            }
            
            sut = try sut.remnant()
        }
    }
    
    // MARK: - Helpers
    
    private var exampleGoal: String { "a goal" }
    private var exampleGoal2: String { "another goal" }

    private func expect(_ expectedError: Plan.Error, when callback: () throws -> (), file: StaticString = #filePath, line: UInt = #line) {

        XCTAssertThrowsError(try callback()) { error in
            switch error as? Plan.Error {
            case expectedError:
                break
            default:
                XCTFail("received error \(String(describing: error))")
            }
        }
    }
    
    private func expectChanges(on sut: Plan, count expected: Int, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows {

        try expectChanges(for: sut.publisher.eraseToAnyPublisher(), count: expected, when: callback)
    }


    
    private func expectNoChanges(on sut: Plan, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows {
        try expectNoChanges(for: sut.publisher.eraseToAnyPublisher(), when: callback)
    }

}
