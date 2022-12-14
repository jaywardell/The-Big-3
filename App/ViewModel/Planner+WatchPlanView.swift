//
//  Planner+WatchPlanView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import Foundation

extension Planner {
    
    func watchPlanViewModel() -> WatchPlanView.ViewModel {
        .init(count: plan.allowed,
              todoAt: todo(at:),
              finish: finishTodo(at:),
              postpone: postponeTodo(at:))
    }
        
    private func finishTodo(at index: Int) {
        try! plan.completeGoal(at: index)
    }
    
    private func postponeTodo(at index: Int) {
        try! plan.deferGoal(at: index)
    }
}
