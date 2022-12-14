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
    
    var body: some View {
        VStack(alignment: .center) {
            Header(alignment: .trailing) { BrandedHeader(layout: .mainTitle) }
                .padding(.bottom)
            
            Spacer()
            
            Header(title: titleText, alignment: .center)
                .padding(.bottom)
                        
            GraphicSummary(viewModel: .init(total: viewModel.total, todoAt: viewModel.todoAt))
                .font(.largeTitle)
            .padding(.bottom)

            Text(completionString)
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.bottom)

            Spacer()

            HStack {
                Spacer()
                Button(action: viewModel.done) {
                    BrandedHeader(layout: .inline)
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
