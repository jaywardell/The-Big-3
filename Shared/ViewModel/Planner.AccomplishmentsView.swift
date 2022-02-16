//
//  Planner.AccomplishmentsView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/9/22.
//

import Foundation

extension Planner {
    
    func accomplishmentsViewModel() -> AccomplishmentsView.ViewModel {
        AccomplishmentsView.ViewModel(count: plan.allowed,
                                      publisher: plan.publisher.eraseToAnyPublisher(),
                                      todoAt: todo(at:),
                                      userIsFinished: userIsFinished,
                                      finish: finishTodo(at:),
                                      postpone: postponeTodo(at:),
                                      done: done)
    }
    
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
    
    private func todo(at index: Int) -> GoalView.ToDo {
        let goal = try! plan.goal(at: index)!
        return GoalView.ToDo(title: goal.title, state: accomplishmentState(for: goal.state))
    }
    
    private func userIsFinished() -> Bool {
        return plan.isComplete
    }

    private func finishTodo(at index: Int) {
        try! plan.completeGoal(at: index)
    }
    
    private func postponeTodo(at index: Int) {
        try! plan.deferGoal(at: index)
    }
    
    private func done() {
        plan = try! plan.remnant()
        state = .planning
    }
 }
