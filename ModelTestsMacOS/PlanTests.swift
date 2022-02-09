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
    
}
