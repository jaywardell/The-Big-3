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

struct CompletionLog {
    
    private(set) var archive: CompletionLogArchive
    
    // TODO: next - break dates up into Days and dates(on day: Date) -> [Date]
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
    
    private mutating func loadArchive() {
        let archived = archive.load()
        self.goalsLogged = archived
        self.dates = archived.keys.sorted()
        
        let allDays = Set(archived.keys.map { Calendar.current.startOfDay(for: $0) })
        self.days = allDays.sorted()
    }
    
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
    
    func timesForGoals(completedOn date: Date) -> [Date] {
        []
    }
    
    func titleForGoal(completedAt date: Date) -> String? {
        goalsLogged[date]
    }
    
}
