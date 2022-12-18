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
    
    @EnvironmentObject private var animation: AnimationNamespace

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
            Header(alignment: .trailing) {
                BrandedHeader(layout: .mainTitle)
                    .matchedGeometryEffect(id: AnimationNamespace.HeaderID, in: animation.id)
            }
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

                Button("Plan the next Big3", action: doneButtonPressed)
                .font(.system(.title, design: .default, weight: .light))
                .padding()
        }
        .padding()
    }
    
    private func doneButtonPressed() {
        withAnimation(.Big3HeaderSpring) {
            viewModel.done()
        }
    }
}

struct SummationView_Previews: PreviewProvider {
    static var previews: some View {
        SummationView(viewModel: .init(total: 3, completed: 3, todoAt: { _ in .init(title: "do something", state: .finished) }, done: {}))
    }
}
