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

    enum Layout { case normal, small, circular }
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

    var linear: some View {
        HStack {
            ForEach(0..<viewModel.total, id: \.self) { index in
                let todo = viewModel.todoAt(index)
                Image(systemName: nameForImage(for: todo))
                    .foregroundColor(color(for: todo))
            }
        }
    }

    private func offset(for index: Int, in size: CGSize) -> CGSize {
        let radius = min(size.width, size.height)/2
        let shift = radius * 34/21 / .pi
        let angle: CGFloat = 2 * .pi * Double(index)/Double(viewModel.total) - .pi/2
        return CGSize(width: cos(angle) * shift,
                      height: sin(angle) * shift)
    }

    private func circleSize(in size: CGSize) -> CGFloat {
        let diameter = min(size.width, size.height)
        return diameter/CGFloat(viewModel.total)
    }
    
    var circular: some View {
        GeometryReader { geometry in
            let circleSize = circleSize(in: geometry.size)
            ZStack {
                ForEach(0..<viewModel.total, id: \.self) { index in
                    let todo = viewModel.todoAt(index)
                    Image(systemName: nameForImage(for: todo))
                        .resizable()
                        .frame(width: circleSize, height: circleSize)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        .offset(offset(for: index, in: geometry.size))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    var body: some View {
        switch layout {
        case .circular: circular
        default: linear
        }
    }

}

struct GraphicSummary_Previews: PreviewProvider {
    static var previews: some View {
        GraphicSummary(viewModel: .init(total: 3, todoAt: { _ in
                .init(title: "", state: .finished)
        }), layout: .circular)
        .previewLayout(.fixed(width: 100, height: 140))
        .previewDisplayName("all finished circular")

        GraphicSummary(viewModel: .init(total: 3, todoAt: { _ in
                .init(title: "", state: .notToday)
        }), layout: .circular)
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("none finished circular")

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
