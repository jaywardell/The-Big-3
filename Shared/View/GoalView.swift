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
    @State private var checkboxTranslation: CGFloat = 0
    @State private var showingPostponeButton = false
    @State private var postponeButtonTranslation: CGFloat = 0

    @Environment(\.colorScheme) var colorScheme
    
    private var dragThreshold: CGFloat { 200 }
    
    var dragControls: some Gesture {
        DragGesture()
            .onChanged { value in
                if value.translation.width > 0 {
                    checkboxTranslation = min(dragThreshold, value.translation.width)
                }
                else {
                    checkboxTranslation = 0
                }
                
                if value.translation.width < 0 {
                    postponeButtonTranslation = max(-dragThreshold, value.translation.width)
                    print(postponeButtonTranslation)
                }
                else {
                    postponeButtonTranslation = 0
                }
            }
            .onEnded { value in
                withAnimation(.Big3Spring) {
                    if value.translation.width > dragThreshold {
                        showingCheckbox = true
                    }
                    else if value.translation.width < 0 {
                        showingCheckbox = false
                    }
                    checkboxTranslation = 0
                    
                    if value.translation.width < -dragThreshold {
                        showingPostponeButton = true
                    }
                    else if value.translation.width > 0 {
                        showingPostponeButton = false
                    }
                    postponeButtonTranslation = 0

                }
            }
    }

    private func textOpacty(for state: ToDo.State) -> CGFloat {
        switch state {
            
        case .ready:
            return 1
        case .finished:
            return 1
        case .notToday:
            return 21/34
        }
    }
    
    private func textColor(for state: ToDo.State) -> Color {
        switch state {
            
        case .ready:
            return backgroundColor
        case .finished:
            return .white
        case .notToday:
            return .primary
        }
    }

    @ViewBuilder private func background(size: CGSize) -> some View {
        
        let todo = todo
        let colors = [ backgroundColor, backgroundColor.opacity(colorScheme == .dark ? 13/34 : 21/34)  ]
        RadialGradient(colors: colorScheme == .dark ? colors : colors.reversed(), center: .center, startRadius: size.width * 1/55, endRadius: size.width)
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
                    Button(action: { withAnimation(.Big3Spring) {finish()}}) {
                            ZStack {
                                Image(systemName: "checkmark.circle")
                                    .resizable()
                                    .foregroundColor(backgroundColor)
                                    .opacity(showingCheckbox ? 8/34 : 3/34)
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundColor(backgroundColor)
                                    .opacity(showingCheckbox ? 1 : checkboxTranslation/dragThreshold)
                            }
                    }
                    .buttonStyle(.borderless)
                case .finished:
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .foregroundColor(.white)
               }
            }
            .frame(width: size.height * 13/34, height: size.height * 13/34)
            
            Spacer()
        }
        .font(.largeTitle)
        .imageScale(.large)
    }
    
    private var checkboxOffsetScalar: CGFloat {
        21/55
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                checkbox(size: geometry.size)
                    .shadow(radius: todo.state == .finished ? geometry.size.height * 3/34 : 0)
                    .padding(.top, geometry.size.height * 8/34)
                    .padding(.leading, geometry.size.height * 3/34)
                    .padding(.trailing, geometry.size.height * 3/34)
                    .offset(x: geometry.size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)
                
                Text(todo.title)
                    .font(.system(size: 1000, weight: .light, design: .serif))
                    .foregroundColor(textColor(for: todo.state))
                    .minimumScaleFactor(0.01)
                    .shadow(radius: todo.state == .finished ? geometry.size.height * 3/34 : 0)
                    .opacity(textOpacty(for: todo.state) )
                    .padding(.vertical, geometry.size.height * 3/34)
                    .padding(.trailing, geometry.size.height * 3/34)
                    .offset(x: geometry.size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)

                Spacer()
                
                if todo.state == .ready {
                ZStack {
                    VStack(alignment: .leading) {

                        Button(action: { withAnimation(.Big3Spring) {postpone()}}) {
                            Text("not today")
                                .font(.system(size: 1000))
                                .minimumScaleFactor(0.01)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                       }
                        .buttonStyle(.borderless)
                    }
                    .foregroundColor(backgroundColor)
                    .opacity(todo.state == .ready ? 1 : 0)
                    .frame(width: geometry.size.height * 8/34,
                           height: geometry.size.height * 8/34)
                }
                .padding(.trailing, geometry.size.height * 5/34)
                .offset(x: geometry.size.width * (showingPostponeButton ? 0 : 8/34) + postponeButtonTranslation, y: 0)
                }
            }
            .background(background(size: geometry.size))
            .contentShape(Rectangle())
            .onTapGesture {
                if todo.state == .ready {
                    withAnimation(.Big3Spring) {
                        if !showingPostponeButton {
                            showingCheckbox.toggle()
                        }
                        showingPostponeButton = false
                    }
                }
            }
            .gesture(dragControls)
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
