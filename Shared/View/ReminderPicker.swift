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

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                if !lister.givenAccess {
                    Text("To import reminders, you must give persmission to do so.")
                }
                else {
                    List {
                        
                    }
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
