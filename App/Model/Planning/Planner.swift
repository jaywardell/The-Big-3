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
