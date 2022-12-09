//
//  LogEntryRow.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/9/22.
//

import SwiftUI

struct LogEntryRow: View {
    
    struct ViewModel: Hashable {
        let time: Date
        let goal: String
    }

    let viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.goal)
                .font(.body)
            Spacer()
            Text(viewModel.time, style: .time)
                .font(.callout)
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }
}

struct LogEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        LogEntryRow(viewModel: .init(time: Date(), goal: "Brush Teeth"))
    }
}
