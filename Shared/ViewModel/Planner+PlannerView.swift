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
                              publisher: plan.publisher.eraseToAnyPublisher(),
                              plannedAt: plannedGoal(at:) ,
                              add: add(planned: at:),
                              remove: removePlanned(at:))
    }
    
    private func plannedGoal(at index: Int) -> PlannerView.ViewModel.Planned? {
        (try? plan.goal(at: index)).map { PlannerView.ViewModel.Planned(title: $0.title) }
    }
    
    private func add(planned: PlannerView.ViewModel.Planned, at index: Int) {
        print(#function, planned, index)
        
        do {
            try plan.set(planned.title.trimmingCharacters(in: .whitespacesAndNewlines), at: index)
        }
        catch {
            print(error)
        }
    }
    
    private func removePlanned(at index: Int) {
        print(#function, index)

        do {
            try plan.removeGoal(at: index)
        }
        catch {
            print(error)
        }
    }
    
}
