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
        Color(hue: 1/2, saturation:21/34, brightness: 26/34),
        Color(hue: 5/8, saturation:21/34, brightness: 26/34),
        Color(hue: 3/4, saturation:21/34, brightness: 26/34)
    ]

}

// MARK: - AccomplishmentsView: View

extension AccomplishmentsView: View {
    
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
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        
        let accomplishment = viewModel.todoAt(index)
        
        HStack {
            
            VStack(alignment: .leading) {
                Spacer()
                switch accomplishment.state {
                case .notToday:
                    Image(systemName: "calendar.badge.clock")
                    Text("postponed")
                case .ready:
                    Button(action: { viewModel.finish(index) }) {
                        VStack(alignment: .leading) {
                       Image(systemName: "circle")
                        Text("done")
                        }
                    }
                    .buttonStyle(.borderless)
                case .finished:
                    Image(systemName: "checkmark.circle")
                    Text("finished")
               }
            }
            .font(.largeTitle)
            .imageScale(.large)
            .padding()

            Spacer()
            
            Text(accomplishment.title)
                .font(.system(size: 1000, weight: .light, design: .serif))
                .minimumScaleFactor(0.01)
                .shadow(radius: accomplishment.state == .finished ? 15 : 0)
                .opacity(textOpacty(for: accomplishment.state) )
            
            Spacer()
            
            VStack(alignment: .leading) {
            Button(action: { viewModel.postpone(index) }) {
                Text("Not Today")
//                Image(systemName: "tortoise")
//                    .padding()
            }
            .buttonStyle(.borderless)
            }
            .font(.largeTitle)
            .imageScale(.large)
            .opacity(accomplishment.state == .ready ? 1 : 0)
            .padding()
        }

    }
    
    @ViewBuilder private func background(at index: Int) -> some View {
        
        let accomplishment = viewModel.todoAt(index)
        Rectangle().fill(accomplishment.state == .finished ? colors[index] : .clear)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...viewModel.count-1, id: \.self) { index in
                
                planBlock(at: index)
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
        return ToDo(title: titles.randomElement()!, state: .finished)

//        return ToDo(title: titles.randomElement()!, state: .allCases.randomElement()!)
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
