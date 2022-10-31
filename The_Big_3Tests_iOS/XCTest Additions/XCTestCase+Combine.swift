//
//  XCTestCase+Combine.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 10/30/22.
//

import XCTest
import Combine

extension XCTestCase {
    
    func expectChanges<Type>(for publisher: AnyPublisher<Type, Never>, count expected: Int, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows where Error == Error {
        
        var callCount = 0
        var bag = Set<AnyCancellable>()
        publisher.sink { _ in
            callCount += 1
        }
        .store(in: &bag)
        
        try callback()
        
        XCTAssertEqual(callCount, expected, file: file, line: line)
    }
    
    func expectNoChanges<Type>(for publisher: AnyPublisher<Type, Never>, when callback: () throws ->(), file: StaticString = #filePath, line: UInt = #line) rethrows {
        try expectChanges(for: publisher, count: 0, when: callback)
    }

}
