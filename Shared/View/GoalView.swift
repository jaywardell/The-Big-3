//
//  GoalView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/10/22.
//

import SwiftUI

struct GoalView: View {
    
    struct ToDo {
        let title: String
        
        enum State: CaseIterable { case ready, finished, notToday }
        let state: State
    }
    
    let todo: ToDo
    let postpone: ()->()
    let finish: ()->()
    
    private func textOpacty(for state: ToDo.State) -> CGFloat {
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
