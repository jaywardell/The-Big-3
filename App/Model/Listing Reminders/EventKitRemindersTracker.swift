//
//  EventKitRemindersTracker.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/13/22.
//

import Foundation
import EventKit
import Combine

/// Given a EKEventStore instance and a predicate to search,
/// this class will retrieve the results of of the predicate
/// and then wait to see if the store changes
/// so it can again retrieve the predicate.
///
/// All updates are sent to the retrieved publisher.
final class EventKitRemindersTracker {
    
    let store: EKEventStore
    let predicate: NSPredicate
    
    let retrieved = CurrentValueSubject<[EKReminder], Never>([])
    
    private var subscriptions = Set<AnyCancellable>()
    init(store: EKEventStore, predicate: NSPredicate) {
        self.store = store
        self.predicate = predicate

        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink(receiveValue: storeWasUpdated(_:))
            .store(in: &subscriptions)
    }
    
    /// NOTE: this method assumes that requestAccess() has already been sent to the store passed in
    /// if it hasn't, then the behavior is undefined and could probably cause a crash
    func retrieveReminders() {
        reloadIncompleteReminders()
    }
    
    private func reloadIncompleteReminders() {
        
        store.fetchReminders(matching: predicate) { [weak self] retrieved in
            guard let reminders = retrieved else { return }
            
            self?.retrieved.send(reminders)
        }
    }

    private func storeWasUpdated(_ notification: Notification) {
        reloadIncompleteReminders()
    }
}
