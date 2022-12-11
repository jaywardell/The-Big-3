//
//  ReminderPicker.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import SwiftUI

struct ReminderPicker: View {
        
    let userChose: (EventKitReminder)->()

    @ObservedObject private var lister = EventKitReminderLister()

    @State private var selectedReminderID: String = ""
    @Environment(\.dismiss) var dismiss

    private var selectedReminder: EventKitReminder? {
        return lister.reminders.first {
            $0.id == selectedReminderID
        }
    }
    
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
                if !lister.givenAccess {
                    Text("To import reminders, you must give persmission to do so.")
                }
                else {
                    List {
                        ForEach(lister.calendars, id: \.self) { calendar in
                            Section(calendar.name) {
                                ForEach(lister.reminders(for: calendar), id: \.self) { reminder in

                                    row(for: reminder)
                                }
                            }
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
            .navigationTitle("Import a Reminder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var clearButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }


    private var doneButton: some View {
        Button("Choose") {
            guard let reminder = selectedReminder else { return }
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
