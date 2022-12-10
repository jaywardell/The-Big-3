//
//  JSONCompletionLogArchive.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation

final class JSONCompletionLogArchive: CompletionLogArchive {
    
    struct Entry: Codable {
        let string: String
        let date: Date
    }
    
    let savePath: URL
    
    static var defaultPathForArchive: URL! {
        try! FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("log", conformingTo: .json)
    }
    
    init(path: URL? = nil) {
        self.savePath = path ?? Self.defaultPathForArchive
    }
    
    private func readArchive() async throws -> [Date : String] {
        guard FileManager.default.fileExists(atPath: savePath.path) else { return [:] }
        
        let decoder = JSONDecoder()
        let data = try Data(contentsOf: savePath)
        return try decoder.decode([Date:String].self, from: data)
    }
    
    func load() async throws -> [Date : String] {
        try await readArchive()
    }
    
    func record(_ string: String, at date: Date) async throws {
        var archive = try await readArchive()
        archive[date] = string
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(archive)
        try data.write(to: savePath)
    }

}
