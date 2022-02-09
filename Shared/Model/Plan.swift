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
    private(set) var goals: [String?]

    var isEmpty: Bool {
        nil == goals.first { $0 != nil }
    }
    
    var isFull: Bool { false }
    
    enum Error: Swift.Error {
        case indexExceedsAllowed
        case goalExistsAtIndex
        case noGoalExistsAtIndex
    }
    
    init(allowed: Int = 0) {
        self.allowed = allowed
        self.goals = Array(repeating: nil, count: allowed)
    }

    @discardableResult
    func goal(at index: Int) throws -> String? {
        guard index < allowed else { throw Error.indexExceedsAllowed }

        return goals[index]
    }
    
    func set(_ goal: String, at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard nil == goals[index] else { throw Error.goalExistsAtIndex }
        goals[index] = goal
    }

    func remove(at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard nil != goals[index] else { throw Error.noGoalExistsAtIndex }

        goals[index] = nil
    }
    
}
