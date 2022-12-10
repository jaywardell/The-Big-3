//
//  EventKitReminderLister.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import EventKit

struct EventKitReminder: Hashable {
    let id: String
    let title: String
}

final class EventKitReminderLister: ObservableObject {
    
    let store = EKEventStore()
    
    @Published var givenAccess = false
    @Published var reminders = [EventKitReminder]()
    
    init() {
        // NOTE: this will cause a crash if there's no NSRemindersUsageDescription ket in Info.plist
        store.requestAccess(to: .reminder) { receivedAccess, error in
            if let error = error {
                print("Error accessing reminders: \(error)")
            }
            
            DispatchQueue.main.async {
                self.givenAccess = receivedAccess
                self.getIncompleteReminders()
            }
        }
    }
    
    private func getIncompleteReminders() {
        let predicate: NSPredicate? = store.predicateForReminders(in: nil)
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [Any]?) -> Void in
                guard let reminders = reminders as? [EKReminder] else { return }
                
                DispatchQueue.main.async {
                    self.reminders = reminders.map { EventKitReminder(id: $0.calendarItemIdentifier, title: $0.title) }
                }
            })
        }
    }
    
}
