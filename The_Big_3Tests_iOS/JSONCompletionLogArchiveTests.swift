//
//  JSONCompletionLogArchiveTests.swift
//  The_Big_3Tests_iOS
//
//  Created by Joseph Wardell on 12/10/22.
//

import XCTest

@testable
import The_Big_3

final class JSONCompletionLogArchiveTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }

    
    func test_load_returns_empty_array_if_no_file_to_load() throws {
        let sut = JSONCompletionLogArchive(path: test_specific_archiveURL())
        
        let archived = try sut.load()
        
        XCTAssert(archived.isEmpty)
    }
    
    func test_load_returns_one_record_if_one_record_was_recorded() throws {
        let writer = JSONCompletionLogArchive(path: test_specific_archiveURL())
        
        let date = Date()
        let string = "1"
        try writer.record(string, at: date)
        
        let sut = JSONCompletionLogArchive(path: test_specific_archiveURL())
        let expected = [date: string]
        
        let archived = try sut.load()
        
        XCTAssertEqual(archived, expected)
    }
    
    func test_stress_test() throws {

        let writer = JSONCompletionLogArchive(path: test_specific_archiveURL())

        var expected = [Date:String]()
        
        try (0...1000).forEach { _ in
            let dateOffset = TimeInterval.random(in: -1_000_000...1_000_000)
            let date = Date().addingTimeInterval(dateOffset)
            let string = "\(date)"
            expected[date] = string
            
            try writer.record(string, at: date)
        }
        
        let sut = JSONCompletionLogArchive(path: test_specific_archiveURL())
        
        let archived = try sut.load()
        
        XCTAssertEqual(archived, expected)
    }
    
    // MARK: - Helpers
    
    private func test_specific_archiveURL() -> URL {
        let out = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
        return out
    }

    fileprivate func deleteStoreArtifacts() -> ()? {
        return try? FileManager.default.removeItem(at: test_specific_archiveURL())
    }

    private func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
        
    private func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }

}
