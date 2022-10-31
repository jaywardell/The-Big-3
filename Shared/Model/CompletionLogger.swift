//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation

struct CompletionLogger {
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    func log(_ goal: Plan.Goal) throws {
        throw Error.GoalIsNotCompleted
    }
    
}
