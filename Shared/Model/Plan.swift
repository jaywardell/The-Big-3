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
final class Plan: Identifiable {
    
    let id: UUID

    let allowed: Int

    struct Goal: Equatable {
        let title: String

        enum State: Equatable { case pending, completed, deferred }
        let state: State
    }
    
    private var goals = [Int: Goal]() {
        didSet {
            publisher.send()
        }
    }
    
    let publisher = PassthroughSubject<Void, Never>()
    
    enum Error: Swift.Error {
        case invalidTitle
        case indexExceedsAllowed
        case goalExistsAtIndex
        case noGoalExistsAtIndex
        case noGoalExistsAtPreviousIndex
        case goalIsAlreadyInPlan
        case goalIsAlreadyDeferred
        case goalIsAlreadyCompleted
        case notComplete
    }

    static var GoalWasCompleted: Notification.Name { Notification.Name(rawValue: #function) }
    
    init(allowed: Int = 0) {
        self.allowed = allowed
        self.id = UUID()
    }
}

// MARK: -

extension Plan {
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
    
    

    @discardableResult
    func goal(at index: Int) throws -> Goal? {
        guard index < allowed else { throw Error.indexExceedsAllowed }

        return goals[index]
    }
        
    func set(_ goal: String, at index: Int) throws {
        let goal = goal //.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !goal.isEmpty else { throw Error.invalidTitle }
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
        
        NotificationCenter.default.post(name: Self.GoalWasCompleted, object: self)
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

// MARK: - Plan: Codable

extension Plan.Goal.State: Codable {}
extension Plan.Goal: Codable {}
extension Plan: Codable {
  
    enum CodingKeys: String, CodingKey {
        case allowed
        case goals
        case id
    }
}
