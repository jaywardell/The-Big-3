//
//  EventKitReminderLister.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import Foundation
import EventKit

final class EventKitReminderLister: ObservableObject {
    
    let store = EKEventStore()
    
    @Published var givenAccess = false
    
    init() {
        // NOTE: this will cause a crash if there's no NSRemindersUsageDescription ket in Info.plist
        store.requestAccess(to: .reminder) { receivedAccess, error in
            if let error = error {
                print("Error accessing reminders: \(error)")
            }
            
            self.givenAccess = receivedAccess
        }
    }
    
}
