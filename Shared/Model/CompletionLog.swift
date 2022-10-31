//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation

struct CompletionLog {
    
    private(set) var dates: [DateComponents] = []
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    func log(_ goal: Plan.Goal) throws {
        guard goal.state == .completed else { throw Error.GoalIsNotCompleted }
    }
    
}
