//
//  EventKitReminderLister.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import EventKit
import Combine

struct EventKitReminder: Hashable {
    let id: String
    let title: String
}

struct EventKitCalendar: Hashable {
    let id: String
    let name: String
    let color: CGColor?
}

final class EventKitReminderLister: ObservableObject {
    
    @Published var givenAccess = false
    @Published private var reminders = [EventKitReminder]()
    @Published var calendars = [EventKitCalendar]()
    @Published private var calendarForReminders = [EventKitCalendar: [EventKitReminder]]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private var tracker: EventKitRemindersTracker
    
    init() {
                
        let store = EKEventStore()
        
        self.tracker = EventKitRemindersTracker(store: store, predicate: store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil))
        self.tracker.retrieved.sink(receiveValue: retrieved(reminders:))
            .store(in: &subscriptions)

        // NOTE: this will cause a crash if there's no NSRemindersUsageDescription set in Info.plist
        store.requestAccess(to: .reminder) { receivedAccess, error in
            if let error = error {
                print("Error accessing reminders: \(error)")
            }
            
            DispatchQueue.main.async {
                self.givenAccess = receivedAccess
                self.tracker.retrieveReminders()
            }
        }
    }
        
    private func retrieved(reminders retrieved: [EKReminder]) {
        let noCalendar = EventKitCalendar(id: "", name: "", color: nil)
        
        var reminders = [EventKitReminder]()
        var calendars = [EventKitCalendar]()
        var calendarForReminders = [EventKitCalendar: [EventKitReminder]]()
        
        for r in retrieved {
            let reminder = EventKitReminder(id: r.calendarItemIdentifier, title: r.title)
            reminders.append(reminder)
            
            let calendar: EventKitCalendar
            if let c = r.calendar {
                calendar = EventKitCalendar(id: c.calendarIdentifier, name: c.title, color: c.cgColor)
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
    
    func reminders(for calendar: EventKitCalendar) -> [EventKitReminder] {
        calendarForReminders[calendar, default: []]
    }
    
    func reminderWith(id: String) -> EventKitReminder? {
        reminders.first {
            $0.id == id
        }
    }
}
