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
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Button("Sleep Well") {
                    choose(Reminder(title: "Sleep Well"))
                }
            }
            .navigationTitle("Import from Reminders")
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
