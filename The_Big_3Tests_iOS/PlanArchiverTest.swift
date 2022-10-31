//
//  PlanArchiverTest.swift
//  ModelTestsMacOS
//
//  Created by Joseph Wardell on 2/16/22.
//

import XCTest
@testable import The_Big_3

class PlanArchiverTest: XCTestCase {

    func test_loadPlan_returns_empty_plan_if_given_empty_data() {
        let sut = PlanArchiver()
        let expectedAllowed = 1
        
        let loaded = sut.loadPlan(allowed: expectedAllowed)
        
        XCTAssertEqual(loaded.allowed, expectedAllowed)
        XCTAssertEqual(loaded.isEmpty, true)
    }
    
    
    func test_loadPlan_returns_any_plan_that_was_passed_in() {
        let sut = PlanArchiver()
        let plan = Plan()
        
        sut.archive(plan)
        
        let loaded = sut.loadPlan(allowed: plan.allowed)
        
        XCTAssertEqual(plan.id, loaded.id)
    }
}
