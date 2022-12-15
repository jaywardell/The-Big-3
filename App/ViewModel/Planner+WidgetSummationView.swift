//
//  Planner+WidgetSummationView.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/15/22.
//

import Foundation

extension Planner {
    
    func summationViewModel() -> WidgetSummationView.ViewModel {
        .init(total: plan.allowed, completed: completedCount, todoAt: todo(at:))
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
