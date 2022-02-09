//
//  Plan.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation

/// represents the User's plan for the current day
/// (or next day if we're in planning mode)
final class Plan {
    
    let allowed: Int
    private(set) var goals: [String] = []

    enum Error: Swift.Error {
        case indexExceedsAllowed
    }
    
    init(allowed: Int = 0) {
        self.allowed = allowed
    }

    @discardableResult
    func goal(at index: Int) throws -> String? {
        guard index < allowed else { throw Error.indexExceedsAllowed }

        return nil
    }
    
}
