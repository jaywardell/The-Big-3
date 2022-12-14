//
//  SummationView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import SwiftUI

struct SummationView: View {
    
    struct ViewModel {
        let total: Int
        let completed: Int
        
        let todoAt: (Int)->GoalView.ToDo

        let done: ()->()
    }
    let viewModel: ViewModel
    
    private var titleText: String {
        switch viewModel.completed {
        case viewModel.total:
            return "Congratulations!"
        default:
            return ""
        }
    }
    
    private var completionString: String {
        var out = "You finished "
        
        switch viewModel.completed {
        case viewModel.total:
            out += "all"
        case 0:
            out += "none"
        default:
            out += String(viewModel.completed)
        }
        
        out += " of the Big 3."
        
        return out
    }
    
    private func nameForImage(for todo: GoalView.ToDo) -> String {
        switch todo.state {
        case .finished: return ViewConstants.finishedImageName
        case .ready: return ViewConstants.unfinishedImageName
        case .notToday: return ViewConstants.deferredImageName
        }
    }

    private func color(for todo: GoalView.ToDo) -> Color {
        switch todo.state {
        case .finished: return .accentColor
        case .ready: return .label
        case .notToday: return .secondary
        }
    }

    var body: some View {
        VStack(alignment: .center) {
            Header(alignment: .trailing) { BrandedHeader(layout: .mainTitle) }
                .padding(.bottom)
            
            Spacer()
            
            Header(title: titleText, alignment: .center)
                .padding(.bottom)
                        
            
            HStack {
                ForEach(0..<viewModel.total, id: \.self) { index in
                    let todo = viewModel.todoAt(index)
                    Image(systemName: nameForImage(for: todo))
                        .font(.largeTitle)
                        .foregroundColor(color(for: todo))
                }
            }
            .padding(.bottom)

            Text(completionString)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.bottom)

            Spacer()

            HStack {
                Spacer()
                Button(action: viewModel.done) {
                    Text("Plan the next Big 3")
                        .font(.system(.title, design: .default, weight: .light))
                }
                .font(.largeTitle)
                .padding()
            }
        }
        .padding()
    }
}

struct SummationView_Previews: PreviewProvider {
    static var previews: some View {
        SummationView(viewModel: .init(total: 3, completed: 3, todoAt: { _ in .init(title: "do something", state: .finished) }, done: {}))
    }
}
