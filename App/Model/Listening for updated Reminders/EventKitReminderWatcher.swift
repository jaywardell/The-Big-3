//
//  EventKitReminderWatcher.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/13/22.
//

import Foundation
import EventKit
import Combine

final class EventKitReminderWatcher {
    
    struct Reminder {
        let id: String
        let isCompleted: Bool
    }
    
    let store = EKEventStore()
    let reminderWasCompleted: (String)->()
    let reminderWasDeleted: (String)->()
    
    private var subscriptions = Set<AnyCancellable>()

    private var remindersForIDs = [String: Reminder]()
    
    init(reminderWasCompleted: @escaping (String)->(), reminderWasDeleted: @escaping (String)->()) {
        self.reminderWasCompleted = reminderWasCompleted
        self.reminderWasDeleted = reminderWasDeleted
        
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: storeWasUpdated(_:))
            .store(in: &subscriptions)
    }
    
    func watchForChangesInRemindersWith(ids: [String]) {
        
        // clear the list
        remindersForIDs = [:]
        
        // rebuild it for any ids that represent reminders in the Reminders app
        for id in ids {
            if let reminder = store.calendarItem(withIdentifier: id) as? EKReminder {
                
                remindersForIDs[id] = Reminder(id: id, isCompleted: reminder.isCompleted)
            }
        }
    }
    
    private func storeWasUpdated(_ notification: Notification) {
        for (id, watched) in remindersForIDs {
            if let reminder = store.calendarItem(withIdentifier: id) as? EKReminder {
                
                if !watched.isCompleted && (watched.isCompleted != reminder.isCompleted) {
                    reminderWasCompleted(id)
                }
            }
            else {
                // it was here before, but now it's gone
                reminderWasDeleted(id)
            }
        }
    }
}
