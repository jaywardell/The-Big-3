//
//  LogView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 3/19/22.
//

import SwiftUI
import Combine

struct LogView: View {
    
    final class ViewModel: ObservableObject {
        @Published var days: [Date]
        let goalsForDay: (Date)->[LogEntryRow.ViewModel]
        
        private var subscriptions = Set<AnyCancellable>()
        init(days: [Date],
             publisher: AnyPublisher<[Date], Never>?,
             goalsForDay: @escaping (Date)->[LogEntryRow.ViewModel]
        ) {
            self.days = days
            self.goalsForDay = goalsForDay
            
            publisher?.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
        }
    }
    
    let viewModel: ViewModel
    
    private func string(for day: Date) -> String {
        DateFormatter.localizedString(from: day, dateStyle: .full, timeStyle: .none)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.days, id: \.self) { day in
                Section(header: Text(string(for:day))) {
                    ForEach(viewModel.goalsForDay(day), id: \.self) {
                        LogEntryRow(viewModel: $0)
                    }
                }
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(viewModel: .init(days: [Date(), Date().addingTimeInterval(24*3600)],
                                 publisher: PassthroughSubject<[Date], Never>().eraseToAnyPublisher(),
                                 goalsForDay: {
            [
                LogEntryRow.ViewModel(time: $0, goal: "something awesome")
            ]
        }))
    }
}
