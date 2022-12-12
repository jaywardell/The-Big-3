//
//  CompletionLog+LogView.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/9/22.
//

import Foundation

extension CompletionLog {
    
    func historyViewModel() -> LogView.ViewModel {
        
        return LogView.ViewModel.init(publisher: logChanged.receive(on: RunLoop.main).eraseToAnyPublisher(),
                                      days: retrieveDays,
                                      goalsForDay: retrieveGoals(for:))
    }
    
    fileprivate func retrieveDays() -> [Date] {
        
        Task { [weak self] in
            await self?.loadArchive()
        }
        
        return days
    }
    
    fileprivate func retrieveGoals(for day: Date) -> [LogEntryRow.ViewModel] {
        timesForGoals(completedOn: day).compactMap {
            guard let goal = titleForGoal(completedAt: $0) else { return nil }
            return LogEntryRow.ViewModel(time: $0, goal: goal)
        }
    }
}
