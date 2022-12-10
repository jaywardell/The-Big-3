//
//  XCTest+AsynAwait.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import XCTest

extension XCTest {
    
    func expect<E: Error>(_ expectedError: E, when callback: () async throws -> (), file: StaticString = #filePath, line: UInt = #line) async where E: Equatable {
        do {
            _ = try await callback()
            XCTFail("Expected to throw error while awaiting, but succeeded", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? E, expectedError, "expected \(expectedError) but got \(error)", file: file, line: line)
        }
    }

    func expectNoError(_ callback: () async throws -> (), file: StaticString = #filePath, line: UInt = #line) async {
        do {
            _ = try await callback()
        } catch {
            XCTFail("Expected to not throw an error, but thres \(error)", file: file, line: line)
        }
    }

}
