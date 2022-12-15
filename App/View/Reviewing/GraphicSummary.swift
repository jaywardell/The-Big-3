//
//  GraphicSummary.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import SwiftUI

struct GraphicSummary: View {
    
    struct ViewModel {
        let total: Int
        
        let todoAt: (Int)->GoalView.ToDo
    }
    let viewModel: ViewModel

    enum Layout { case normal, small }
    let layout: Layout
    
    init(viewModel: ViewModel, layout: Layout = .normal) {
        self.viewModel = viewModel
        self.layout = layout
    }
    
    private func nameForImage(for todo: GoalView.ToDo) -> String {
        switch todo.state {
        case .finished: return layout == .small ? ViewConstants.smallFinishedImageName : ViewConstants.finishedImageName
        case .ready: return ViewConstants.unfinishedImageName
        case .notToday: return ViewConstants.deferredImageName
        }
    }

    private func color(for todo: GoalView.ToDo) -> Color {
        if layout == .small {
            return .label
        }
        else {
            switch todo.state {
            case .finished: return .accentColor
            case .ready: return .label
            case .notToday: return .secondary
            }
        }
    }

    var body: some View {
        HStack {
            ForEach(0..<viewModel.total, id: \.self) { index in
                let todo = viewModel.todoAt(index)
                Image(systemName: nameForImage(for: todo))
                    .foregroundColor(color(for: todo))
            }
        }
    }
}

struct GraphicSummary_Previews: PreviewProvider {
    static var previews: some View {
        GraphicSummary(viewModel: .init(total: 3, todoAt: { _ in
                .init(title: "", state: .finished)
        }))
        .previewLayout(.sizeThatFits)
        .previewDisplayName("all finished")

        GraphicSummary(viewModel: .init(total: 3, todoAt: { _ in
                .init(title: "", state: .notToday)
        }))
        .previewLayout(.sizeThatFits)
        .previewDisplayName("none finished")
    }
}
