//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation

protocol CompletionLogArchive {
    func load() -> [Date: String]
}

struct CompletionLog {
    
    private(set) var archive: CompletionLogArchive
    private(set) var dates: [Date] = []
    private var goalsLogged = [Date:String]()
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    init(archive: CompletionLogArchive) {
        self.archive = archive
        
        self.dates = Array(archive.load().keys)
    }
    
    mutating func log(_ goal: Plan.Goal, date: Date = Date()) throws {
        guard goal.state == .completed else { throw Error.GoalIsNotCompleted }
        
        dates.append(date)
        dates.sort()
        
        goalsLogged[date] = goal.title
    }
    
    func titleForGoal(completedAt date: Date) -> String? {
        goalsLogged[date]
    }
    
}
