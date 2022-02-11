//
//  AccomplishmentsView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/9/22.
//

import SwiftUI
import Combine


struct AccomplishmentsView {
    
    final class ViewModel: ObservableObject {
        let count: Int
        
        let todoAt: (Int)->GoalView.ToDo
        let finish: (Int)->()
        let postpone: (Int)->()
        let done: ()->()

        private var bag = Set<AnyCancellable>()
        init(count: Int,
             publisher: AnyPublisher<Void, Never>?,
             todoAt: @escaping (Int)->GoalView.ToDo,
             finish: @escaping (Int)->(),
             postpone: @escaping (Int)->(),
             done: @escaping ()->()) {
            
            self.count = count
            self.todoAt = todoAt
            self.finish = finish
            self.postpone = postpone
            self.done = done
            
            publisher?.sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &bag)
        }
    }
    @ObservedObject var viewModel: ViewModel

    let colors = [
        Color(hue: 5/8, saturation:26/34, brightness: 26/34),
        Color(hue: 1/2, saturation:26/34, brightness: 26/34),
        Color(hue: 3/4, saturation:26/34, brightness: 26/34)
    ]

}

// MARK: - AccomplishmentsView: View

extension AccomplishmentsView: View {
            
    
    var body: some View {
        VStack(spacing: 5) {
            ForEach(0...viewModel.count-1, id: \.self) { index in
                
                GoalView(todo: viewModel.todoAt(index), backgroundColor: colors[index], postpone: { viewModel.postpone(index) }, finish: { viewModel.finish(index) })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .padding(.vertical)
        .navigationTitle("Today")
    }
}

// MARK: -

#if DEBUG

fileprivate extension AccomplishmentsView.ViewModel {
    
    static var ExamplePlan: [GoalView.ToDo] = []
    
    static func randomToD() -> GoalView.ToDo {
            
        let titles = [
        "eat",
        "sleep",
        "be merry",
        "pray",
        "love",
        "live",
        "laugh"
        ]
//        return ToDo(title: titles.randomElement()!, state: .finished)

        return GoalView.ToDo(title: titles.randomElement()!, state: .allCases.randomElement()!)
    }
    
    static let Example = AccomplishmentsView.ViewModel(count: 3, publisher: nil, todoAt: { _ in randomToD() }, finish: { _ in }, postpone: { _ in }, done: {})
}


struct AccomplishmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AccomplishmentsView(viewModel: .Example)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
