//
//  ReminderPicker.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import SwiftUI

protocol ReminderPickerCalendar {
    var name: String { get }
    var color: Color { get }
}

protocol ReminderPickerReminder {
    var title: String { get }
}

protocol ReminderPickerViewModel: ObservableObject {
    var givenAccess: Bool { get }
    var calendars: [ReminderPickerCalendar] { get }

    func reminders(for calendar: ReminderPickerCalendar) -> [ReminderPickerReminder]
    func reminderWith(id: String) -> ReminderPickerReminder?
}

// MARK: -

struct ReminderPicker: View {
        
    let userChose: (EventKitReminder)->()

    @StateObject private var viewModel = EventKitReminderLister()

    @State private var selectedReminderID: String = ""
    @Environment(\.dismiss) var dismiss
    
    private func row(for reminder: EventKitReminder) -> some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(reminder.id == selectedReminderID ? 1 : 0)
            Text(reminder.title)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2, perform: {
            choose(reminder)
        })
        .onTapGesture {
            selectedReminderID = reminder.id
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.givenAccess {
                    VStack {
                        ScrollView {
                            Text(
"""
The Big 3 can use your existing reminders from your Reminders app as goals.

You can use reminders in The Big 3 and when you mark them as completed, they'll show up as completed in your Reminders app as well.

This is a great way to use The Big 3 to focus on just the things you want to do right now, while you plan your tasks out in Reminders.

If you want to do this, you'll need to turn on support for Reminders in the Settings app.

• Open Settings

• Navigate to the settings pane for 'The Big 3'

• Turn on the toggle for Reminders.

• Come back here and choose a reminder that you want to track in 'The Big 3'
"""
                            )
                            .padding()
                            Spacer()
                        }}
                }
                else if viewModel.calendars.isEmpty {
                    VStack {
                        Text(
"""
It looks like there are no reminders in you Reminders app.

You can still add goals directly in 'The Big 3'

or you can open the Reminders app and add some goals there, then come back here and select them to be tracked in 'The Big 3'
"""
                        )
                        Spacer()
                    }
                        .padding()
                }
                else {
                    List {
                        ForEach(viewModel.calendars, id: \.id) { calendar in
                            Section(calendar.name) {
                                ForEach(viewModel.reminders(for: calendar), id: \.id) { reminder in

                                    row(for: reminder)
                                        .foregroundColor(.label)
                                }
                            }
                            .foregroundColor(calendar.color.map(Color.init(cgColor:)) ?? .label)
                        }
                    }
                    .listStyle(.plain)
                }

                HStack {
                    clearButton
                    Spacer()
                    doneButton
                }
                .padding()
            }
            .navigationTitle("Pick a Reminder")
        }
    }
    
    private var clearButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }


    private var doneButton: some View {
        Button("Choose") {
            guard let reminder = viewModel.reminderWith(id: selectedReminderID) else { return }
            userChose(reminder)
            dismiss()
        }
        .buttonStyle(.borderedProminent)
        .disabled(selectedReminderID.isEmpty)
    }

    private func choose(_ reminder: EventKitReminder) {
        dismiss()
        userChose(reminder)
    }
}

struct ReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        ReminderPicker() { _ in }
    }
}
