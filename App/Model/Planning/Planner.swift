//
//  Planner.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation
import Combine

final class Planner: ObservableObject {
        
    enum State { case planning, doing }
    
    @Published var state: State = .planning
    
    @Published var plan: Plan
    
    init(plan: Plan = Plan(allowed: 3)) {
        self.plan = plan
        self.state = plan.isFull ? .doing : .planning
    }
    
    func completeGoalWith(externalIdentifier id: String) {
        switch state {
        case .planning:
            removeAnyGoalWith(externalIdentifier: id)
        case .doing:
            markAsCompletedAnyGoalWith(externalIdentifier: id)
        }
    }
    
    func deleteGoalWith(externalIdentifier id: String) {
        switch state {
        case .planning:
            removeAnyGoalWith(externalIdentifier: id)
        case .doing:
            // if we're past the planning stage,
            // then just deleting the goal
            // could be confusing to the user
            // so let the goal stay
            //
            // it won't matter when it's
            // completed in the app
            break
        }
    }
    
    private func markAsCompletedAnyGoalWith(externalIdentifier id: String) {
        for index in 0..<plan.allowed {
            if let goal = try? plan.goal(at: index),
               goal.externalIdentifier == id {
                try? plan.completeGoal(at: index)
            }
        }
    }
    
    private func removeAnyGoalWith(externalIdentifier id: String) {
        for index in 0..<plan.allowed {
            if let goal = try? plan.goal(at: index),
               goal.externalIdentifier == id {
                try? plan.removeGoal(at: index)
            }
        }
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case plan
        case state
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        plan = try values.decode(Plan.self, forKey: .plan)
        state = try values.decode(State.self, forKey: .state)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(plan, forKey: .plan)
        try container.encode(state, forKey: .state)
    }

}

extension Planner.State: Codable {}
extension Planner: Codable {}

extension Planner.State: CustomStringConvertible {
    var description: String {
        switch self {
        case .planning: return "Planning"
        case .doing: return "Doing"
        }
    }
}
extension Planner: CustomStringConvertible {
    var description: String {
        return state.description + "\n" + plan.description
    }
}

#if DEBUG
// MARK: -


extension Plan {
    
    static let emptyExample: Plan = Plan(allowed: 3)
    
    static let example: Plan = {
        let out = Plan(allowed: 3)
        
        try! out.set("Do the dishes", at: 0)
        try! out.set("Wash the sink", at: 1)
        try! out.set("Pet the cat", at: 2)
        
        return out
    }()
    
    static let example2: Plan = {
        let out = Plan(allowed: 3)

        try! out.set("Do the dishes", at: 0)
        try! out.set("Wash the sink", at: 1)
        try! out.set("Pet the cat", at: 2)

        try! out.completeGoal(at: 0)
        try! out.deferGoal(at: 2)

        return out
    }()
}
#endif
