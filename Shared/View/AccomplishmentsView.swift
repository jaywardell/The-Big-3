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
            
            enum State: CaseIterable { case ready, finished, notToday }
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
        Color(hue: 5/8, saturation:26/34, brightness: 26/34),
        Color(hue: 1/2, saturation:26/34, brightness: 26/34),
        Color(hue: 3/4, saturation:26/34, brightness: 26/34)
    ]

}

extension AccomplishmentsView {
    
    struct PlanBlock: View {
        
        let todo: ViewModel.ToDo
        let postpone: ()->()
        let finish: ()->()
        
        private func textOpacty(for state: AccomplishmentsView.ViewModel.ToDo.State) -> CGFloat {
            switch state {
                
            case .ready:
                return 21/34
            case .finished:
                return 1
            case .notToday:
                return 13/34
            }
        }

        
        
        var body: some View {
            HStack {
                    Group {
                        switch todo.state {
                        case .notToday:
                            Image(systemName: "circle")
                                .hidden()
                        case .ready:
                            Button(action: finish) {
                                VStack(alignment: .leading) {
                               Image(systemName: "circle")
                                }
                            }
                            .buttonStyle(.borderless)
                        case .finished:
                            Image(systemName: "checkmark.circle")
                       }
                    }
                .font(.largeTitle)
                .imageScale(.large)
                .padding(.leading)
                
                Text(todo.title)
                    .font(.system(size: 1000, weight: .light, design: .serif))
                    .minimumScaleFactor(0.01)
                    .shadow(radius: todo.state == .finished ? 15 : 0)
                    .opacity(textOpacty(for: todo.state) )
                    .padding(.vertical)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Button(action: postpone) {
                        Text("Not Today")
                    }
                    .buttonStyle(.borderless)
                }
                .font(.largeTitle)
                .imageScale(.large)
                .opacity(todo.state == .ready ? 1 : 0)
                .padding()
            }
        }
    }

}

// MARK: - AccomplishmentsView: View

extension AccomplishmentsView: View {
            
    @ViewBuilder private func background(at index: Int) -> some View {
        
        let accomplishment = viewModel.todoAt(index)
        Rectangle().fill(accomplishment.state == .finished ? colors[index] : .clear)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...viewModel.count-1, id: \.self) { index in
                
                PlanBlock(todo: viewModel.todoAt(index), postpone: { viewModel.postpone(index) }, finish: { viewModel.finish(index) })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(background(at: index))
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
//        return ToDo(title: titles.randomElement()!, state: .finished)

        return ToDo(title: titles.randomElement()!, state: .allCases.randomElement()!)
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
