//
//  CompletionLog+LogView.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/9/22.
//

import Foundation

extension CompletionLog {
    
    func historyViewModel() -> LogView.ViewModel {
        
        return .init(publisher: logChanged.receive(on: RunLoop.main).eraseToAnyPublisher(),
              days: {
            Task {
                await self.loadArchive()
            }

            return self.days } )
        { day in
            
            
            return self.timesForGoals(completedOn: day).compactMap {
                guard let goal = self.titleForGoal(completedAt: $0) else { return nil }
                return LogEntryRow.ViewModel(time: $0, goal: goal)
            }
        }
    }
    
}
