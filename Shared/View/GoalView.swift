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
    
    @State private var showingCheckbox = false
    
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
    
    @ViewBuilder private func background(size: CGSize) -> some View {
        
        let todo = todo
        RadialGradient(colors: [ backgroundColor, backgroundColor.opacity(13/34)  ], center: .center, startRadius: size.width * 1/55, endRadius: size.width)
            .opacity(todo.state == .finished ? 1 : 0)
    }

    private func checkbox(size: CGSize) -> some View {
        VStack {
            Group {
                switch todo.state {
                case .notToday:
                    Image(systemName: "circle.slash")
                        .resizable()
                        .opacity(textOpacty(for: .notToday))

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
            .frame(width: size.height * 13/34, height: size.height * 13/34)
            
            Spacer()
            
//            Text("(postponed)")
//                .lineLimit(1)
//                .font(.system(size: size.height * 5/34, weight: .bold, design: .rounded))
//                .minimumScaleFactor(0.01)
//                .opacity(todo.state == .notToday ? 1 : 0)
//                .padding(.bottom, size.height * 5/34)
//                .opacity(textOpacty(for: todo.state) )
        }
        .font(.largeTitle)
        .imageScale(.large)
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                checkbox(size: geometry.size)
                    .shadow(radius: todo.state == .finished ? geometry.size.height * 3/34 : 0)
                    .padding(.top, geometry.size.height * 8/34)
                    .padding(.leading, geometry.size.height * 3/34)
                    .padding(.trailing, geometry.size.height * 3/34)
                    .offset(x: geometry.size.width * ((showingCheckbox || todo.state != .ready) ? 0 : -13/34), y: 0)
                
                Text(todo.title)
                    .font(.system(size: 1000, weight: .light, design: .serif))
                    .minimumScaleFactor(0.01)
                    .shadow(radius: todo.state == .finished ? geometry.size.height * 3/34 : 0)
                    .opacity(textOpacty(for: todo.state) )
                    .padding(.vertical)
                
                Spacer()
                
                ZStack {
                    VStack(alignment: .leading) {
                        Button(action: postpone) {
                            Image(systemName: "arrow.uturn.right.circle")
                                .resizable()
                                .imageScale(.large)
                       }
                        .buttonStyle(.borderless)
                        .opacity(textOpacty(for: .notToday))
                    }
                    .opacity(todo.state == .ready ? 1 : 0)
                    .frame(width: geometry.size.height * 8/34, height: geometry.size.height * 8/34)
                }
                .padding(.leading, geometry.size.height * 3/34)
                .padding(.trailing, geometry.size.height * 5/34)
            }
            .background(background(size: geometry.size))
            .onTapGesture {
                if todo.state == .ready {
                    withAnimation(.spring(response: 21/34.0, dampingFraction: 13/34.0, blendDuration: 21/34.0)) {
                        showingCheckbox.toggle()
                    }
                }
            }
        }
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
