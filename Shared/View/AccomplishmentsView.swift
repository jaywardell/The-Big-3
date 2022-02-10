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
        struct ToDo {
            let title: String
            
            enum State { case ready, finished, notToday }
            let state: State
        }
        
        let count: Int
        
        let todoAt: (Int)->ToDo
        let finish: (Int)->()
        let postpone: (Int)->()
        let done: ()->()

        private var bag = Set<AnyCancellable>()
        init(count: Int,
             publisher: AnyPublisher<Void, Never>?,
             todoAt: @escaping (Int)->ToDo,
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
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34),
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34),
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34)
    ]

}


extension AccomplishmentsView: View {
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        
        let accomplishment = viewModel.todoAt(index)
        
        Text(accomplishment.title)
            .font(.system(size: 1000, weight: .light, design: .serif))
            .minimumScaleFactor(0.01)
            .shadow(radius: 15)

    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...viewModel.count-1, id: \.self) { index in
                
                planBlock(at: index)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Rectangle().fill(colors[index])
                    )
            }
        }
    }
}

// MARK: -

#if DEBUG

fileprivate extension AccomplishmentsView.ViewModel {
    
    static var ExamplePlan: [AccomplishmentsView.ViewModel.ToDo] = []
    
    static func randomToD() -> ToDo {
            
        let titles = [
        "eat",
        "sleep",
        "be merry",
        "pray",
        "love",
        "live",
        "laugh"
        ]
        return ToDo(title: titles.randomElement()!, state: .ready)
    }
    
    static let Example = AccomplishmentsView.ViewModel(count: 3, publisher: nil, todoAt: { _ in randomToD() }, finish: { _ in }, postpone: { _ in }, done: {})
}


struct AccomplishmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AccomplishmentsView(viewModel: .Example)
    }
}
#endif
