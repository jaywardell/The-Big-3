//
//  GoalView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/10/22.
//

import SwiftUI

struct GoalView: View {
    
    struct ToDo: Hashable {
        let title: String
        
        enum State: CaseIterable { case ready, finished, notToday }
        let state: State
    }
    
    let todo: ToDo
    let backgroundColor: Color
    
    enum Template {
        case iOSApp(postpone: ()->(), finish: ()->())

        case minimalWidget
        case veboseWidget
        
        case watch(showDetail: ()->())
        
        var isiOSApp: Bool {
            if case .iOSApp = self { return true }
            return false
        }
    }
    
    let template: Template
    
    @State private var showingCheckbox = true
    @State private var checkboxTranslation: CGFloat = 0
    @State private var showingPostponeButton = false
    @State private var postponeButtonTranslation: CGFloat = 0

    @Environment(\.colorScheme) var colorScheme
    
    private var dragThreshold: CGFloat {
        #if os(watchOS)
        50
        #else
        200
        #endif
    }
    
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
            #if os(iOS)
            return .secondaryLabel
            #else
            return Color(cgColor: .init(gray: 0.8, alpha: 1))
            #endif
        }
    }

    @ViewBuilder private func background(size: CGSize) -> some View {
        
        let todo = todo
        let colors = [ backgroundColor, backgroundColor.opacity(colorScheme == .dark ? 13/34 : 21/34)  ]
        let gradient = RadialGradient(colors: colorScheme == .dark ? colors : colors.reversed(), center: .center, startRadius: size.width * 1/55, endRadius: size.width)
        
#if os(watchOS)
        RoundedRectangle(cornerRadius: size.height * 17/34)
            .fill(gradient)
            .padding(1)
            .padding(.top, size.height * 2/34)
            .opacity(todo.state == .finished ? 1 : 0)
#else
        gradient
            .opacity(todo.state == .finished ? 1 : 0)
#endif
    }
    
    private func checkbox(size: CGSize) -> some View {
        VStack {
            Group {
                switch todo.state {
                case .notToday:
                    Image(systemName: ViewConstants.deferredImageName)
                        .resizable()
                        .foregroundColor(textColor(for: .notToday))
                        .opacity(textOpacty(for: .notToday))

                case .ready:
                    Button(action: finishButtonPressed) {
                            ZStack {
                                Image(systemName: ViewConstants.unfinishedImageName)
                                    .resizable()
                                    .foregroundColor(backgroundColor)
                                    .opacity(checkboxOpacity)
                            }
                    }
                    .buttonStyle(.borderless)
                case .finished:
                    Image(systemName: ViewConstants.finishedImageName)
                        .resizable()
                        .foregroundColor(.white)
               }
            }
            .font(.system(size: size.height * checkboxScaleFactor, weight: .ultraLight))
            .frame(width: size.height * checkboxScaleFactor, height: size.height * checkboxScaleFactor)
            
            Spacer()
        }
        .font(.largeTitle)
        .imageScale(.large)
    }
    
    private var checkboxScaleFactor: CGFloat {
        switch template {
        case .iOSApp:
            return 13/34
        default:
            return 21/34
        }
    }
    
    private var checkboxOpacity: CGFloat {
        switch template {
        case .iOSApp:
            return (showingCheckbox ? 8/34 : 3/34)
        default:
            return 1
        }
    }

    private var checkmarkOpacity: CGFloat {
        switch template {
        case .iOSApp:
            return (showingCheckbox ? 5/34 : 3/34)
        default:
            return 1
        }
    }

    private var checkboxOffsetScalar: CGFloat {
        21/55
    }
    
    private var textFontScalar: CGFloat {
        #if os(watchOS)
        21/34
        #else
        13/34
        #endif
    }
        
    private func deferButtonWidth(in size: CGSize) -> CGFloat {
        size.height * 13/34
    }
    
    private func deferButton(inContainerWithSize size: CGSize) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .leading) {
                
                Button(action: deferButtonPressed) {
                    Text("not today")
                        .font(.body)
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .opacity(showingPostponeButton ? 1 : 0)
                }
                
                .buttonStyle(.borderless)
            }
            .opacity(todo.state == .ready ? 1 : 0)
#if os(iOS)
            .frame(width: deferButtonWidth(in: size),
                   height: size.height * 8/34)
#else
            .frame(width: deferButtonWidth(in: size),
                   height: size.height * 13/34)
#endif
            .padding(.horizontal)
            .background(
                Capsule()
                    .stroke(Color.accentColor, lineWidth: 2)
                    .background(
                        Capsule()
                            .fill(Color.systemBackground)
                            .shadow(radius: showingPostponeButton ? 2 : 0)
                    )
            )
        }
    }
    private func bigBody(size: CGSize) -> some View {
        ZStack {
            HStack {
                checkbox(size: size)
                    .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                    .padding(.top, size.height * 8/34)
                    .padding(.leading, size.height * 3/34)
                    .padding(.trailing, size.height * 3/34)
                    .offset(x: size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)
                
                Text(todo.title)
                    .font(.system(size: size.height * textFontScalar, weight: .ultraLight))
                    .foregroundColor(textColor(for: todo.state))
                    .minimumScaleFactor(5/34)
                    .opacity(showingPostponeButton ? 21/34 : 1)
                    .blur(radius: showingPostponeButton ? 1 : 0)
                    .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                    .opacity(textOpacty(for: todo.state) )
#if os(iOS)
                    .padding(.vertical, size.height * 3/34)
#endif
                    .offset(x: size.height * ((showingCheckbox || todo.state != .ready) ? 0 : -checkboxOffsetScalar) + checkboxTranslation, y: 0)
                
                Spacer()
            }

            if todo.state == .ready {
                deferButton(inContainerWithSize: size)
                .padding(.trailing, size.height * 5/34)
                .offset(x: deferredButtonOffset(for: size) + postponeButtonTranslation + (showingCheckbox ? size.width : 0), y: 0)
            }        }
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

    private func deferredButtonOffset(for size: CGSize) -> CGFloat {
        #if os(iOS)
        showingPostponeButton ? 0 : deferButtonWidth(in: size) * 26/21
        #else
        size.width * (showingPostponeButton ? 0 : 13/34)
        #endif
    }

    private func finishButtonPressed() {
        switch template {
            
        case .iOSApp(_, let finish):
            withAnimation(.Big3Spring) {
                finish()
            }
            
        case .watch:
            watchRowWasTapped()
            
        default:
            break
        }
    }
    
    private func deferButtonPressed() {
        if showingPostponeButton {
            guard case let .iOSApp(postpone, _) = template else { return }
            withAnimation(.Big3Spring) {
                postpone()
            }
        }
        else {
            withAnimation(.Big3Spring) {
                showingPostponeButton = true
            }
        }
    }
    
    private func smallBody(size: CGSize) -> some View {
        HStack {
            Spacer()
            checkbox(size: size)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .padding(.top, size.height * 8/34)
            Spacer()
        }
        .background(background(size: size))
        .contentShape(Rectangle())
    }

    private func mediumBody(size: CGSize) -> some View {
        HStack {
            checkbox(size: size)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .padding(.top, size.height * 8/34)
                .padding(.leading, size.height * 8/34)
            
            Text(todo.title)
                .font(.system(size: size.height * 13/34, weight: .light))
                .foregroundColor(textColor(for: todo.state))
                .minimumScaleFactor(5/34)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)

            Spacer()
        }
        .background(background(size: size))
        .contentShape(Rectangle())
    }

    private func watchBody(size: CGSize) -> some View {
        HStack {
            checkbox(size: size)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)
                .padding(.top, size.height * 8/34)
                .padding(.leading, size.height * 8/34)
            
            Text(todo.title)
                .font(.system(size: size.height * 13/34, weight: .light))
                .foregroundColor(textColor(for: todo.state))
                .minimumScaleFactor(5/34)
                .shadow(radius: todo.state == .finished ? size.height * 3/34 : 0)

            Spacer()
        }
        .background(background(size: size))
        .contentShape(Rectangle())
        .onTapGesture(perform: watchRowWasTapped)
    }

    private func watchRowWasTapped() {
        guard case let .watch(wasTapped) = template else { return }
        
        wasTapped()
    }
    
    var body: some View {
        GeometryReader { geometry in
            switch template {
            case .iOSApp:
                bigBody(size: geometry.size)
                
            case .veboseWidget:
                mediumBody(size: geometry.size)
            case .minimalWidget:
                smallBody(size: geometry.size)
                
            case .watch:
                watchBody(size: geometry.size)
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
                     backgroundColor: .purple, template: .iOSApp(postpone: {}, finish: {}))

            GoalView(todo: GoalView.ToDo(title: "brush my teeth", state: .ready),
                     backgroundColor: .purple, template: .iOSApp(postpone: {}, finish: {}))

            GoalView(todo: GoalView.ToDo(title: "comb hair", state: .notToday),
                     backgroundColor: .purple, template: .iOSApp(postpone: {}, finish: {}))
        }
        .previewLayout(.fixed(width: 300, height: 300))
        .previewDisplayName("Regular")

        VStack {
            GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .finished),
                     backgroundColor: .purple, template: .veboseWidget)

            GoalView(todo: GoalView.ToDo(title: "brush my teeth", state: .ready),
                     backgroundColor: .purple, template: .veboseWidget)

            GoalView(todo: GoalView.ToDo(title: "comb hair", state: .notToday),
                     backgroundColor: .purple, template: .veboseWidget)
        }
        .previewLayout(.fixed(width: 300, height: 100))
        .previewDisplayName("medium")

        VStack {
            GoalView(todo: GoalView.ToDo(title: "wash my hands", state: .finished),
                     backgroundColor: .purple, template: .minimalWidget)

            GoalView(todo: GoalView.ToDo(title: "brush my teeth", state: .ready),
                     backgroundColor: .purple, template: .minimalWidget)

            GoalView(todo: GoalView.ToDo(title: "comb hair", state: .notToday),
                     backgroundColor: .purple, template: .minimalWidget)
        }
        .previewLayout(.fixed(width: 100, height: 100))
        .previewDisplayName("Small")
    }
}
#endif
