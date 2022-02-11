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
    let backgroundColor: Color
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
    
    @ViewBuilder private var background: some View {
        
        let todo = todo
        Rectangle().fill(todo.state == .finished ? backgroundColor : .clear)
    }

    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Group {
                    switch todo.state {
                    case .notToday:
                        Image(systemName: "circle")
                            .resizable()
                            .hidden()
                    case .ready:
                        Button(action: finish) {
                                ZStack {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .opacity(3/34)
                                    Image(systemName: "circle")
                                        .resizable()
                                        .foregroundColor(backgroundColor)
                                }
                        }
                        .buttonStyle(.borderless)
                    case .finished:
                        Image(systemName: "checkmark.circle")
                            .resizable()
                   }
                }
                .frame(width: geometry.size.height * 13/34, height: geometry.size.height * 13/34)
                .font(.largeTitle)
                .imageScale(.large)
                .shadow(radius: todo.state == .finished ? 15 : 0)
                .padding(.leading)
                
                Text(todo.title)
                    .font(.system(size: 1000, weight: .light, design: .serif))
                    .minimumScaleFactor(0.01)
                    .shadow(radius: todo.state == .finished ? 15 : 0)
                    .opacity(textOpacty(for: todo.state) )
                    .padding(.vertical)
                
                Spacer()
                
                ZStack {
                    VStack(alignment: .leading) {
                        Button(action: postpone) {
                            Text("postpone")
                                .lineLimit(1)
                                .font(.system(size: 1000, weight: .bold, design: .rounded))
                                .minimumScaleFactor(0.01)
                       }
                        .buttonStyle(.borderless)
                        .foregroundColor(backgroundColor)
                    }
                    .opacity(todo.state == .ready ? 1 : 0)
                    .frame(height: geometry.size.height * 13/34)
                    
                    VStack {
                        Spacer()
                        Text("(not today)")
                            .lineLimit(1)
                            .font(.system(size: geometry.size.height * 5/34, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.01)
                            .opacity(todo.state == .notToday ? 1 : 0)
                            .padding(.bottom, geometry.size.height * 5/34)
                            .opacity(textOpacty(for: todo.state) )
                   }
                }
                .padding(.leading, geometry.size.width * 5/34)
                .padding(.trailing, geometry.size.width * 3/34)
            }
        }
        .background(background)
    }
}

// MARK: -

#if DEBUG
struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .finished),
                 backgroundColor: .orange, postpone: {}, finish: {})
            .previewLayout(.fixed(width: 300, height: 100))

        GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .ready),
                 backgroundColor: .orange, postpone: {}, finish: {})
            .previewLayout(.fixed(width: 300, height: 100))

        GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .notToday),
                 backgroundColor: .orange, postpone: {}, finish: {})
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
#endif
