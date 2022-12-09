//
//  CompletionLog+LogView.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/9/22.
//

import Foundation

extension CompletionLog {
    
    func historyViewModel() -> LogView.ViewModel {
        .init(days: days, publisher: logChanged.eraseToAnyPublisher() ) { day in
            timesForGoals(completedOn: day).compactMap {
                guard let goal = titleForGoal(completedAt: $0) else { return nil }
                return LogEntryRow.ViewModel(time: $0, goal: goal)
            }
        }
    }
    
}
