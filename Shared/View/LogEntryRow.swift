//
//  LogEntryRow.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/9/22.
//

import SwiftUI

struct LogEntryRow: View {
    
    let time: Date
    let goal: String
    
    var body: some View {
        HStack {
            Text(goal)
                .font(.body)
            Spacer()
            Text(time, style: .time)
                .font(.callout)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}

struct LogEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryRow(time: Date(), goal: "Brush Teeth")
    }
}
