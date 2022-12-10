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
    
    func load() -> [Date : String] {
        [:]
    }
    
    func record(_ string: String, at date: Date) throws {
                
    }

}
