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
        let days: ()->[Date]
        let goalsForDay: (Date)->[LogEntryRow.ViewModel]
        
        private var subscriptions = Set<AnyCancellable>()
        init(publisher: AnyPublisher<[Date], Never>?,
             days: @escaping ()->[Date],
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
    
    @ObservedObject var viewModel: ViewModel

    private func string(for day: Date) -> String {
        DateFormatter.localizedString(from: day, dateStyle: .full, timeStyle: .none)
    }
    
    // we want to show the days in reverse-chronological order
    // so that the most recent goal achievements are at the top
    private var daysInOrder: [Date] {
        viewModel.days().sorted { $0 > $1 }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(daysInOrder, id: \.self) { day in
                        Section(header: Text(string(for:day))) {
                            ForEach(viewModel.goalsForDay(day), id: \.self) {
                                LogEntryRow(viewModel: $0)
//                                    .foregroundColor(.label)
                            }
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                .listStyle(.plain)
                
                if viewModel.days().isEmpty {
                    VStack {
                        Text("When you've completed some of your Big 3 goals, you'll see them here.")
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("History")
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView(viewModel: .init(publisher: PassthroughSubject<[Date], Never>().eraseToAnyPublisher(),
                                 days: {
            [Date(),
             Date().addingTimeInterval(24*3600),
             Date().addingTimeInterval(2*24*3600)
            ] },
                                 goalsForDay: {
            [
                LogEntryRow.ViewModel(time: $0, goal: "something awesome"),
                LogEntryRow.ViewModel(time: $0, goal: "something awesome"),
                LogEntryRow.ViewModel(time: $0, goal: "something awesome")
            ]
        }))
        .previewDisplayName("full")

        LogView(viewModel: .init(publisher: PassthroughSubject<[Date], Never>().eraseToAnyPublisher(),
                                 days: { [] },
                                 goalsForDay: { _ in [] }))
        .previewDisplayName("empty")
    }
}
