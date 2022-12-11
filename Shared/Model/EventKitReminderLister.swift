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

struct EventKitCalendar: Hashable {
    let id: String
    let name: String
}

final class EventKitReminderLister: ObservableObject {
    
    let store = EKEventStore()
    
    @Published var givenAccess = false
    @Published var reminders = [EventKitReminder]()
    @Published var calendars = [EventKitCalendar]()
    @Published var calendarForReminders = [EventKitCalendar: [EventKitReminder]]()
    
    init() {
        // NOTE: this will cause a crash if there's no NSRemindersUsageDescription set in Info.plist
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
        let predicate: NSPredicate? = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        if let aPredicate = predicate {
            store.fetchReminders(matching: aPredicate) { [weak self] reminders in
                guard let reminders = reminders else { return }

                self?.retrieved(reminders: reminders)
            }
        }
    }
    
    private func retrieved(reminders retrieved: [EKReminder]) {
        let noCalendar = EventKitCalendar(id: "", name: "")
        
        var reminders = [EventKitReminder]()
        var calendars = [EventKitCalendar]()
        var calendarForReminders = [EventKitCalendar: [EventKitReminder]]()
        
        for r in retrieved {
            let reminder = EventKitReminder(id: r.calendarItemIdentifier, title: r.title)
            reminders.append(reminder)
            
            let calendar: EventKitCalendar
            if let c = r.calendar {
                calendar = EventKitCalendar(id: c.calendarIdentifier, name: c.title)
            }
            else {
                calendar = noCalendar
            }
            if !calendars.contains(calendar) {
                calendars.append(calendar)
            }
            
            var remindersForCalendar = calendarForReminders[calendar, default: []]
            remindersForCalendar.append(reminder)
            calendarForReminders[calendar] = remindersForCalendar
        }
        
        DispatchQueue.main.async {
            self.reminders = reminders
            self.calendars = calendars
            self.calendarForReminders = calendarForReminders
        }
    }
}
