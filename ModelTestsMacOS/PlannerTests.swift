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

    func test_planner_passes_changes_from_plan_on_to_subscribers() throws {
        let sut = Planner()
        
        try expectChanges(on: sut, count: 1) {
            try sut.plan.set("example", at: 0)
        }
    }
    
    // MARK: - Helpers
    
    private func expectChanges(on sut: Planner, count expected: Int, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows {
        
        var callCount = 0
        var bag = Set<AnyCancellable>()
        sut.objectWillChange.sink {
            callCount += 1
        }
        .store(in: &bag)
        
        try callback()
        
        XCTAssertEqual(callCount, expected, file: file, line: line)

    }

}
