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
    
    enum Template { case small, regular }
    
    let template: Template
    
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
                                if template == .regular {
                                    Image(systemName: "checkmark.circle")
                                        .resizable()
                                        .foregroundColor(self.template == .regular ? backgroundColor : Color(uiColor: .label))
                                        .opacity(self.template == .regular ? (showingCheckbox ? 8/34 : 3/34) : 1)
                                }
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundColor(backgroundColor)
                                    .opacity(self.template == .regular ? (showingCheckbox ? 8/34 : 3/34) : 1)
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
    
    private func bigBody(size: CGSize) -> some View {
        HStack {
            checkbox(size: size)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .padding(.top, size.height * 8/34)
                .padding(.leading, size.height * 3/34)
                .padding(.trailing, size.height * 3/34)
                .offset(x: size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)
            
            Text(todo.title)
                .font(.system(size: 1000, weight: .light, design: .serif))
                .foregroundColor(textColor(for: todo.state))
                .minimumScaleFactor(0.01)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .opacity(textOpacty(for: todo.state) )
                .padding(.vertical, size.height * 3/34)
                .padding(.trailing, size.height * 3/34)
                .offset(x: size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)

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
                .frame(width: size.height * 8/34,
                       height: size.height * 8/34)
            }
            .padding(.trailing, size.height * 5/34)
            .offset(x: size.width * (showingPostponeButton ? 0 : 8/34) + postponeButtonTranslation, y: 0)
            }
        }
        .background(background(size: size))
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

    private func smallBody(size: CGSize) -> some View {
        HStack {
            Spacer()
            checkbox(size: size)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .padding(.top, size.height * 8/34)
//                .padding(.leading, size.height * 3/34)
//                .padding(.trailing, size.height * 3/34)
//                .offset(x: size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)
            Spacer()
            

        }
        .background(background(size: size))
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

    var body: some View {
        GeometryReader { geometry in
            switch template {
            case .regular:
                bigBody(size: geometry.size)
            case .small:
                smallBody(size: geometry.size)
            }
        }
    }
}

// MARK: -

#if DEBUG
struct MyPreviewProvider_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .finished),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .regular)

            GoalView(todo: GoalView.ToDo(title: "brush my teeth", state: .ready),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .regular)

            GoalView(todo: GoalView.ToDo(title: "comb hair", state: .notToday),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .regular)
        }
        .previewLayout(.fixed(width: 300, height: 300))
        .previewDisplayName("Regular")

        VStack {
            GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .finished),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .small)

            GoalView(todo: GoalView.ToDo(title: "brush my teeth", state: .ready),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .small)

            GoalView(todo: GoalView.ToDo(title: "comb hair", state: .notToday),
                     backgroundColor: .purple, postpone: {}, finish: {}, template: .small)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Small")
    }
}
#endif
