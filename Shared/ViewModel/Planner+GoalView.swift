//
//  Planner+GoalView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation

extension Planner {
    
    private func accomplishmentState(for state: Plan.Goal.State) -> GoalView.ToDo.State {
        switch state {
        case .pending:
            return .ready
        case .completed:
            return .finished
        case .deferred:
            return .notToday
        }
    }

    func todo(at index: Int) -> GoalView.ToDo {
        let goal = try! plan.goal(at: index)!
        return GoalView.ToDo(title: goal.title, state: accomplishmentState(for: goal.state))
    }

}
