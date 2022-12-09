//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation

struct CompletionLog {
    
    private(set) var dates: [Date] = []
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    mutating func log(_ goal: Plan.Goal, date: Date = Date()) throws {
        guard goal.state == .completed else { throw Error.GoalIsNotCompleted }
        
        dates.append(date)
    }
    
    func titleForGoal(completedAt date: Date) -> String? {
        nil
    }
    
}
