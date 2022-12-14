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
        case 0:
            return "Oh Well"
        default:
            return "Alright"
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
    
    var body: some View {
        VStack(alignment: .center) {
            Header(title: titleText)
                        
            Spacer()

            
            Text(completionString)
                .font(.title2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack {
                ForEach(0..<viewModel.total, id: \.self) { index in
                    let todo = viewModel.todoAt(index)
                    Image(systemName: nameForImage(for: todo))
                        .font(.largeTitle)
                }
            }
            
            Spacer()
            Spacer()
            Spacer()

            HStack {
                Spacer()
                Button(action: viewModel.done) {
                    BrandedHeader(layout: .planningTitle)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .padding()
    }
}

struct SummationView_Previews: PreviewProvider {
    static var previews: some View {
        SummationView(viewModel: .init(total: 3, completed: 0, todoAt: { _ in .init(title: "do something", state: .notToday) }, done: {}))
    }
}
