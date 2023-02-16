//
//  EventKitReminderLister+ReminderPickerViewModel.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 2/16/23.
//

import SwiftUI

extension EventKitReminder: ReminderPickerReminder {}
extension EventKitCalendar: ReminderPickerCalendar {
    var color: Color {
        cgColor.map { Color($0) } ?? .label
    }
}

extension EventKitReminderLister: ReminderPickerViewModel {
    typealias Calendar = EventKitCalendar
    typealias Reminder = EventKitReminder
}

extension ReminderPicker where ViewModel == EventKitReminderLister {
    init(_ userChose: @escaping (ViewModel.Reminder)->()) {
        self.init(viewModel: EventKitReminderLister.shared, userChose: userChose)
    }
}
