//
//  EventKitGoalService.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import EventKit

final class EventKitGoalService: ExternalGoalServiceBridge {
    
    let store = EKEventStore()
    
    func checkUserAllowsAccess(_ completion: @escaping (Bool) -> ()) {
        store.requestAccess(to: .reminder) { allowed, error in
            completion(allowed && (error == nil))
        }
    }
    
    func getReminder(for id: String) -> NSObject? {
        store.calendarItem(withIdentifier: id) as? EKReminder
    }
    
    func complete(_ object: NSObject) {
        guard let reminder = object as? EKReminder else { return }
        
        reminder.completionDate = Date()
        
        do {
            try store.save(reminder, commit: true)
        }
        catch {
            print("error completing reminder \(reminder): \(error)")
        }
    }
    
    
}
