//
//  XCTestCase+Combine.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 10/30/22.
//

import XCTest
import Combine

extension XCTestCase {
    
    func expectChanges<Type>(for publisher: AnyPublisher<Type, Never>, count expected: Int, when callback: () async throws ->(), file: StaticString = #filePath, line: UInt = #line) async rethrows where Error == Error {
        
        var callCount = 0
        let expectation = XCTestExpectation(description: "expect changes for publisher")
        var bag = Set<AnyCancellable>()
        publisher.sink { _ in
            callCount += 1
            expectation.fulfill()
        }
        .store(in: &bag)
        
        try await callback()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(callCount, expected, file: file, line: line)
    }

    func expectChanges<Type>(for publisher: AnyPublisher<Type, Never>, count expected: Int, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows where Error == Error {
        
        var callCount = 0
        let expectation = XCTestExpectation(description: "expect changes for publisher")
        var bag = Set<AnyCancellable>()
        publisher.sink { _ in
            callCount += 1
            expectation.fulfill()
        }
        .store(in: &bag)
        
        try callback()
        
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(callCount, expected, file: file, line: line)
    }
    
    func expectNoChanges<Type>(for publisher: AnyPublisher<Type, Never>, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows {
        
        var callCount = 0
        let expectation = XCTestExpectation(description: "expect changes for publisher")
        expectation.isInverted = true
        var bag = Set<AnyCancellable>()
        publisher.sink { _ in
            callCount += 1
            expectation.fulfill()
        }
        .store(in: &bag)
        
        try callback()
        
        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(callCount, 0, file: file, line: line)
    }

}
