//
//  ReminderPicker.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/10/22.
//

import SwiftUI

struct ReminderPicker: View {
    
    
    struct Reminder {
        let title: String
    }
    
    let userChose: (Reminder)->()

    @ObservedObject private var lister = EventKitReminderLister()

    @State private var selectedReminderID: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                if !lister.givenAccess {
                    Text("To import reminders, you must give persmission to do so.")
                }
                else {
                    List {
                        ForEach(lister.reminders, id: \.self) { reminder in
                            
                            HStack {
                                Image(systemName: "checkmark")
                                    .opacity(reminder.id == selectedReminderID ? 1 : 0)
                                Text(reminder.title)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedReminderID = reminder.id
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Import a Reminder")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func choose(_ reminder: Reminder) {
        dismiss()
        userChose(reminder)
    }
}

struct ReminderPicker_Previews: PreviewProvider {
    static var previews: some View {
        ReminderPicker() { _ in }
    }
}
