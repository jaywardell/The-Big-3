//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation

protocol CompletionLogArchive {
    func load() -> [Date: String]
    func record(_ string: String, at date: Date)
}

// MARK: -

struct CompletionLog {
    
    private(set) var archive: CompletionLogArchive
    
    private(set) var days: [Date] = []
    private(set) var dates: [Date] = []
    private var goalsLogged = [Date:String]()
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    init(archive: CompletionLogArchive) {

        self.archive = archive
        loadArchive()
    }
    
    // MARK: -
            
    /// return an array of dates representing the times on the day for the time passed in when a goal was logged
    /// - Parameter date: a date that represents the day we're looking for
    /// - Returns: an array of Date objects between the beginning and ending of the day for the date passed in
    func timesForGoals(completedOn date: Date) -> [Date] {
        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.startOfDay(for: date.addingTimeInterval(24*3600))
        
        return dates.filter {
            $0 >= start && $0 < end
        }
    }
    
    func titleForGoal(completedAt date: Date) -> String? {
        goalsLogged[date]
    }
    
    // MARK: -
    
    mutating func log(_ goal: Plan.Goal, date: Date = Date()) throws {
        guard goal.state == .completed else { throw Error.GoalIsNotCompleted }
        
        dates.append(date)
        dates.sort()
        
        var newDays = Set(days)
        newDays.insert(Calendar.current.startOfDay(for: date))
        days = newDays.sorted()
        goalsLogged[date] = goal.title
        
        archive.record(goal.title, at: date)
    }
    
    private mutating func loadArchive() {
        let archived = archive.load()
        self.goalsLogged = archived
        self.dates = archived.keys.sorted()
        
        let allDays = Set(archived.keys.map { Calendar.current.startOfDay(for: $0) })
        self.days = allDays.sorted()
    }
}


// MARK: -

struct MockCompletionLogArchive: CompletionLogArchive {
    
    let exampleData: [Date:String]
    
    init(exampleDate: [Date:String]) {
        self.exampleData = exampleDate
    }
    
    func load() -> [Date: String] {
        return exampleData
    }
    
    func record(_ string: String, at date: Date) {}
}

