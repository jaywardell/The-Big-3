//
//  CompletionLogger.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 10/31/22.
//

import Foundation
import Combine

protocol CompletionLogArchive {
    func load() async throws -> [Date: String]
    func record(_ string: String, at date: Date) async throws
}

// MARK: -


final class CompletionLog {
    
    private(set) var archive: CompletionLogArchive
    
    let logChanged = PassthroughSubject<[Date], Never>()
    
    // this approach uses a lot of data structures to do something fairly simple
    // but the amount of data should never be that big
    // (maybe in the thousands after years of use)
    // so speed is more important than memory used
    // which should alos be negligible
    private(set) var days: [Date] = []
    private var datesForDay = [Date: [Date]]()
    private var goalsLogged = [Date:String]()
    
    enum Error: Swift.Error {
        case Unknown
        case GoalIsNotCompleted
    }
    
    actor Flag {
        
        init(_ initialValue: Bool) {
            self.isSet = initialValue
        }
        
        var isSet: Bool
        
        func set() { self.isSet = true }
    }

    private var hasLoadedArchive = Flag(false)
    
    // MARK: -
    
    init(archive: CompletionLogArchive) {

        self.archive = archive
    }
    
    // MARK: -
            
    /// return an array of dates representing the times on the day for the time passed in when a goal was logged
    /// - Parameter date: a date that represents the day we're looking for
    /// - Returns: an array of Date objects between the beginning and ending of the day for the date passed in
    func timesForGoals(completedOn date: Date) -> [Date] {
        let day = Calendar.current.startOfDay(for: date)
        return datesForDay[day, default: []]
    }
    
    func titleForGoal(completedAt date: Date) -> String? {
        goalsLogged[date]
    }
    
    // MARK: -
    
    func log(_ goal: Plan.Goal, date: Date = Date()) async throws {
        guard goal.state == .completed else { throw Error.GoalIsNotCompleted }
                
        // make sure that the archive has been loaded before trying to modify it
        await loadArchive()
        
        let day = Calendar.current.startOfDay(for: date)

        var newDays = Set(days)
        newDays.insert(day)
        days = newDays.sorted()
        
        goalsLogged[date] = goal.title

        var dates = datesForDay[day, default: []]
        dates.append(date)
        datesForDay[day] = dates.sorted()
        
        try await archive.record(goal.title, at: date)
        
        DispatchQueue.main.async {
            self.logChanged.send(self.days)
        }
    }
    
    func loadArchive() async {
        guard await !hasLoadedArchive.isSet else { return }
        
        do {
            let archived = try await archive.load()
            self.goalsLogged = archived
            let dates = archived.keys.sorted()
            
            let allDays = Set(archived.keys.map { Calendar.current.startOfDay(for: $0) })
            self.days = allDays.sorted()
            
            for date in dates {
                let day = Calendar.current.startOfDay(for: date)
                var dates = datesForDay[day, default: []]
                dates.append(date)
                datesForDay[day] = dates
            }
            await hasLoadedArchive.set()

            DispatchQueue.main.async {
                self.logChanged.send(self.days)
            }
        }
        catch {
            print("Error loading log of completed goals: \(error)")
        }
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

