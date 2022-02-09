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
}
