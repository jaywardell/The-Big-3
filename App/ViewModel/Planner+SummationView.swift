//
//  Planner+SummationView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import Foundation

extension Planner {
    
    func summationViewModel() -> SummationView.ViewModel {
        .init(total: plan.allowed, completed: completedCount, todoAt: todo(at:), done: summationViewFinished)
    }
    
    private var completedCount: Int {
        plan.currentGoals.reduce(0) {
            $0 + ($1?.state == .completed ? 1 : 0)
        }
    }
    
    private func summationViewFinished() {
        plan = try! plan.remnant()
        state = .planning
    }
}
