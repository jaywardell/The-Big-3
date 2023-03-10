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
        let userIsFinished: ()->Bool
        let finish: (Int)->()
        let postpone: (Int)->()
        let done: ()->()

        private var bag = Set<AnyCancellable>()
        init(count: Int,
             publisher: AnyPublisher<Void, Never>?,
             todoAt: @escaping (Int)->GoalView.ToDo,
             userIsFinished: @escaping ()->Bool,
             finish: @escaping (Int)->(),
             postpone: @escaping (Int)->(),
             done: @escaping ()->()) {
            
            self.count = count
            self.todoAt = todoAt
            self.userIsFinished = userIsFinished
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

#if os(iOS)
    @Environment(\.showHistory) var showHistory
#endif
    
    let colors = [
        Color.accentColor,
        Color.accentColor.opacity(31/34),
        Color.accentColor.opacity(29/34),
    ]

    @EnvironmentObject private var animation: AnimationNamespace

}

// MARK: - AccomplishmentsView: View

extension AccomplishmentsView: View {
    
    private func template(for index: Int) -> GoalView.Template {
        GoalView.Template.iOSApp(
            postpone: { viewModel.postpone(index) },
            finish: { viewModel.finish(index) })
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            Header(alignment: .center) {
                    BrandedHeader(layout: .mainTitle)
                    .matchedGeometryEffect(id: AnimationNamespace.HeaderID, in: animation.id)

            }
            Divider()
            
            CountedRows(rows: viewModel.count) { index in
                return GoalView(todo: viewModel.todoAt(index), backgroundColor: colors[index], template: template(for: index))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
#if os(iOS)
            HStack {
                Button(action: showHistory) {
                    Image(systemName: "list.bullet")
                }
                Spacer()
                Button(action: doneButtonPressed) {
                    Text("Done")
                }
                .font(.system(.title, design: .default, weight: .light))
                .padding()
                .opacity(viewModel.userIsFinished() ? 1 : 0)
            }
            .padding()
            .padding(.bottom)
#endif
        }
    }
    
    private func doneButtonPressed() {
        withAnimation(.Big3HeaderSpring) {
            viewModel.done()
        }
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

        return GoalView.ToDo(title: titles.randomElement()!, state: .finished)
    }
    
    static let Example = AccomplishmentsView.ViewModel(count: 3, publisher: nil, todoAt: { _ in randomToD() }, userIsFinished: { false }, finish: { _ in }, postpone: { _ in }, done: {})
}


struct AccomplishmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AccomplishmentsView(viewModel: .Example)
            .previewLayout(.fixed(width: 300, height: 300))
    }
}
#endif
