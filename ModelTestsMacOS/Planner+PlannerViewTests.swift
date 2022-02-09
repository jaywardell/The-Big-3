//
//  Planner+PlannerViewTests.swift
//  ModelTestsMacOS
//
//  Created by Joseph Wardell on 2/9/22.
//

import XCTest

@testable
import The_Big_3

class Planner_PlannerViewTests: XCTestCase {

    func test_plannerViewModel_sets_allowed_from_plan() {
        let sut = Planner()
        
        XCTAssertEqual(sut.plannerViewModel().allowed, sut.plan.allowed)
    }
    
}
