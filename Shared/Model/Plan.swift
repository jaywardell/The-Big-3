//
//  Plan.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation
import Combine

/// represents the User's plan for the current day
/// (or next day if we're in planning mode)
final class Plan {
    
    enum State: Equatable { case pending, completed, deferred }
    
    struct Goal: Equatable {
        let title: String
        let state: State
    }
    
    let allowed: Int
    
    private var goals = [Int: Goal]() {
        didSet {
            publisher.send()
        }
    }
    
    let publisher = PassthroughSubject<Void, Never>()
    
    var isEmpty: Bool {
        goals.isEmpty
    }
    
    var isFull: Bool {
        goals.count == allowed
    }
    
    var isComplete: Bool {
        let pending = goals.values.filter { $0.state == .pending }
        return isFull && pending.count == 0
    }
    
    enum Error: Swift.Error {
        case indexExceedsAllowed
        case goalExistsAtIndex
        case noGoalExistsAtIndex
        case noGoalExistsAtPreviousIndex
        case goalIsAlreadyInPlan
        case goalIsAlreadyDeferred
        case goalIsAlreadyCompleted
        case notComplete
    }
    
    init(allowed: Int = 0) {
        self.allowed = allowed
    }

    @discardableResult
    func goal(at index: Int) throws -> Goal? {
        guard index < allowed else { throw Error.indexExceedsAllowed }

        return goals[index]
    }
        
    func set(_ goal: String, at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard nil == goals[index] else { throw Error.goalExistsAtIndex }
        guard !goals.values.contains(where: { $0.title == goal }) else { throw Error.goalIsAlreadyInPlan }
        goals[index] = Goal(title: goal, state: .pending)
    }

    func removeGoal(at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard nil != goals[index] else { throw Error.noGoalExistsAtIndex }

        goals[index] = nil
    }
    
    func deferGoal(at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard let goal = goals[index] else { throw Error.noGoalExistsAtIndex }
        guard goal.state != .deferred else { throw Error.goalIsAlreadyDeferred }
        guard goal.state != .completed else { throw Error.goalIsAlreadyCompleted }
        
        goals[index] = Goal(title: goal.title, state: .deferred)
    }
    
    func completeGoal(at index: Int) throws {
        guard index < allowed else { throw Error.indexExceedsAllowed }
        guard let goal = goals[index] else { throw Error.noGoalExistsAtIndex }
        guard goal.state != .completed else { throw Error.goalIsAlreadyCompleted }

        goals[index] = Goal(title: goal.title, state: .completed)
    }
    
    func remnant() throws -> Plan {
        guard isComplete else { throw Error.notComplete }
        
        let out = Plan(allowed: allowed)
        
        for i in 0..<allowed {
            if let goal = try goal(at: i) {
                if goal.state == .deferred {
                    try out.set(goal.title, at: i)
                }
            }
        }
        
        return out
    }
}
