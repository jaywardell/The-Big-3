//
//  Planner+PlannerView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/9/22.
//

import Foundation

extension Planner {
    
    func plannerViewModel() -> PlannerView.ViewModel {
        PlannerView.ViewModel(allowed: plan.allowed,
                              // TODO: can I achieve what I want by passing the plan's publisher and forgetting about Planner being an ObservableObject?
                              publisher: objectWillChange.eraseToAnyPublisher(),
                              plannedAt: { _ in nil },
                              add: { _, _ in },
                              remove: {_ in })
    }
    
}
