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
        HStack(alignment: .top) {
            Text(viewModel.goal)
                .font(.body)
                .foregroundColor(.label)
            Spacer()
            Text(viewModel.time, style: .time)
                .font(.callout)
                .foregroundColor(.secondaryLabel)
        }
    }
}

struct LogEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            LogEntryRow(viewModel: .init(time: Date(), goal: "Brush Teeth"))
            LogEntryRow(viewModel: .init(time: Date(), goal: "figure out if I really believe that the universe is continually expanding or whethere it's just an illusion caused by some other property of space-time that causes a red shift at extreme distance"))
        }
    }
}
