//
//  PlannerTests.swift
//  ModelViewTestsMacOS
//
//  Created by Joseph Wardell on 2/8/22.
//

import XCTest
import Combine

@testable
import The_Big_3

class PlannerTests: XCTestCase {

    func test_init_sets_plan_to_empty_plan() {
        let sut = Planner()
        
        XCTAssert(sut.plan.isEmpty)
    }

    func test_init_sets_plan_to_empty_plan_with_3_allowed_goals() {
        let sut = Planner()
        
        XCTAssertEqual(sut.plan.allowed, 3)
    }
    
    func test_completeGoalWithID_does_nothing_if_goal_not_in_plan() {
        let sut = Planner(plan: .example)
        
        sut.completeGoalWith(externalIdentifier: UUID().uuidString)
        
        XCTAssertEqual(sut.plan.currentGoals, Plan.example.currentGoals)
    }
    
    func test_completeGoalWithID_removes_goal_if_still_planning() throws {
        let sut = Planner(plan: Plan(allowed: 3))
        let identifier = UUID().uuidString
        try sut.plan.set("example", identifier: identifier, at: 1)
        
        sut.completeGoalWith(externalIdentifier: identifier)
        
        XCTAssert(sut.plan.isEmpty)
    }
    
    func test_completeGoalWithID_set_goal_tocompleted_if_done_planning() throws {
        
        let identifier = UUID().uuidString
        let plan = Plan(allowed: 1)
        try plan.set("example", identifier: identifier, at: 0)
        let sut = Planner(plan: plan)
                
        sut.completeGoalWith(externalIdentifier: identifier)
        
        XCTAssert(!sut.plan.isEmpty)
        XCTAssertEqual(try? sut.plan.goal(at: 0)?.state, .completed)
    }

    func test_deleteGoalWithID_does_nothing_if_goal_not_in_plan() {
        let sut = Planner(plan: .example)
        
        sut.deleteGoalWith(externalIdentifier: UUID().uuidString)
        
        XCTAssertEqual(sut.plan.currentGoals, Plan.example.currentGoals)
    }

    func test_deleteGoalWithID_removes_goal_if_still_planning() throws {
        let sut = Planner(plan: Plan(allowed: 3))
        let identifier = UUID().uuidString
        try sut.plan.set("example", identifier: identifier, at: 1)
        
        sut.deleteGoalWith(externalIdentifier: identifier)
        
        XCTAssert(sut.plan.isEmpty)
    }

    func test_deleteGoalWithID_does_nothing_if_done_planning() throws {
        
        let identifier = UUID().uuidString
        let plan = Plan(allowed: 1)
        try plan.set("example", identifier: identifier, at: 0)
        let sut = Planner(plan: plan)
                
        sut.deleteGoalWith(externalIdentifier: identifier)
        
        XCTAssert(!sut.plan.isEmpty)
        XCTAssertEqual(sut.plan.currentGoals, plan.currentGoals)
    }

}
