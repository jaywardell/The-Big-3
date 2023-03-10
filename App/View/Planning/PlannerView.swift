//
//  PlannerView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI
import Combine

struct PlannerView {
    
    final class ViewModel: ObservableObject {
        struct Planned {
            let title: String
        }

        let allowed: Int

        let plannedAt: (Int)->Planned?
        let isFull: ()->Bool
        let add: (Planned, Int)->()
        let importReminder: (EventKitReminder, Int)->()
        let remove: (Int)->()
        let start: ()->()

        private var subscriptions = Set<AnyCancellable>()
        init(allowed: Int,
             publisher: AnyPublisher<Void, Never>?,
             plannedAt: @escaping (Int)->Planned?,
             isFull: @escaping ()->Bool,
             add: @escaping (Planned, Int)->(),
             importReminder: @escaping (EventKitReminder, Int)->(),
             remove: @escaping (Int)->(),
             start: @escaping ()->()) {
            
            self.allowed = allowed
            self.plannedAt = plannedAt
            self.isFull = isFull
            self.add = add
            self.importReminder = importReminder
            self.remove = remove
            self.start = start
            
            publisher?.sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &subscriptions)
        }
    }
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedIndex: Int?
    @State private var newPlannedTitle: String = ""
    
    @State private var showingReminderPicker = false
    
    @State private var tappedDeleteButtonIndex: Int?
    
    @State private var showingKeyboard = false
    
    @Environment(\.showHistory) var showHistory
    
    @EnvironmentObject private var animation: AnimationNamespace
    
    @FocusState private var isFocused: Bool

    let colors = [
        Color.accentColor,
        Color.accentColor.opacity(31/34),
        Color.accentColor.opacity(29/34),
    ]
}

// MARK: - PlannerView: View

extension PlannerView: View {
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        if let planned = viewModel.plannedAt(index) {
            HStack {
                                
                VStack {
                    Text(planned.title)
                        .font(.largeTitle)
                        .minimumScaleFactor(0.01)
                        .foregroundColor(.white)
                        .shadow(radius: 15)
                    
                    Spacer()
                }

                Spacer()
                
                VStack {
                    Spacer()
                    Button(action: { userTappedDeleteGoal(at: index) }) {
                        Image(systemName: tappedDeleteButtonIndex == index ? "xmark.circle.fill" : "minus.circle.fill")
                            .font(.largeTitle).imageScale(.large)
                    }
                    .buttonStyle(.borderless)
                    .accentColor(.white)
                    .rotationEffect(.degrees(tappedDeleteButtonIndex == index ?  90 : 0))
                   .shadow(radius: 15)
                }
            }
            .padding()
        }
        else if index == selectedIndex {
            VStack(alignment: .leading) {
                TextField("enter a goal???", text: $newPlannedTitle)
                    .focused($isFocused)
                    .font(.largeTitle)
                    .minimumScaleFactor(0.1)
                    .onAppear { isFocused = true }
                    .onSubmit {
                        setTitleForSelectedField()
                    }
                
                Spacer()
                
                Button(action: showRemindersPicker) {
                    Text("Use a Reminder???")
                        .font(.footnote)
                }
            }
            .padding()
        }
        else if index == 0 || viewModel.plannedAt(index-1) != nil {
            HStack {
                Spacer()

                VStack {
                    Spacer()

                    Button(action: { userTappedEmptyPlannedBlock(at: index) }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .minimumScaleFactor(0.1)
                            .imageScale(.large)
                    }
                    .buttonStyle(.borderless)

                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                userTappedEmptyPlannedBlock(at: index)
            }
            .padding()
        }
        else {
            // to ensure spacing
            HStack {}
        }
    }
        
    private func setTitleForSelectedField() {
        guard let selectedIndex = selectedIndex else { return }
        userEnteredNewPlannedTitle(newPlannedTitle, at: selectedIndex)
        newPlannedTitle = ""
        self.selectedIndex = nil
    }
    
    @ViewBuilder private func background(at index: Int) -> some View {
        
        if nil != viewModel.plannedAt(index)  {
            
            let colors = [ colors[index], colors[index].opacity(13/34)  ]
            RadialGradient(colors: colors, center: .center, startRadius: 0, endRadius: 1000)
        }
    }

    var body: some View {
        
        VStack(spacing: 0) {
            
            Header(alignment: .leading) {
                BrandedHeader(layout: .planningTitle)
                    .matchedGeometryEffect(id: AnimationNamespace.HeaderID, in: animation.id)
            }
            .opacity(showingKeyboard ? 0 : 1)
            Divider()
            
            CountedRows(rows: viewModel.allowed) { index in
                planBlock(at: index)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(background(at: index)
                    )
            }
            
            if !showingKeyboard {
                HStack {
                    Button(action: showHistory) {
                        Image(systemName: "list.bullet")
                    }
                    Spacer()
                    Button(action: startButtonPressed) {
                        Text("Start")
                            .font(.system(.title, design: .default, weight: .light))
                    }
                    .font(.largeTitle)
                    .padding()
                    .opacity(viewModel.isFull() ? 1 : 0)
                }
                .padding()
            }
        }
#if os(iOS)
        .onReceive(Publishers.showingKeyboard) {
            showingKeyboard = $0 }
#endif

        .sheet(isPresented: $showingReminderPicker) {
            ReminderPicker() {
                guard let index = selectedIndex else { return }
                viewModel.importReminder($0, index)
            }
        }
    }
        
    private func startButtonPressed() {
        withAnimation(.Big3HeaderSpring) {
            viewModel.start()
        }
    }
    
    private func showRemindersPicker() {
        showingReminderPicker = true
    }
        
    private func userTappedEmptyPlannedBlock(at index: Int) {
        selectedIndex = index
    }

    private func userTappedDeleteGoal(at index: Int) {
        withAnimation(.Big3Spring) {
            if let tappedDeleteButtonIndex = tappedDeleteButtonIndex,
               tappedDeleteButtonIndex == index {
                viewModel.remove(tappedDeleteButtonIndex)
                self.tappedDeleteButtonIndex = nil
            }
            else {
                tappedDeleteButtonIndex = index
            }
        }
    }
    
    private func userEnteredNewPlannedTitle(_ newPlannedTitle: String, at index: Int) {
        withAnimation(.Big3Spring) {
            viewModel.add(ViewModel.Planned(title: newPlannedTitle), index)
        }
    }
    
}

// MARK: - PlannerView.ViewModel Example Data

#if DEBUG

fileprivate extension PlannerView.ViewModel {
    
    static var ExamplePlan: [PlannerView.ViewModel.Planned] = []
    
    static func randomPlanned() -> Planned? {
        if Bool.random() { return nil }
            
        let titles = [
        "eat",
        "sleep",
        "be merry",
        "pray",
        "love",
        "live",
        "laugh"
        ]
        return Planned(title: titles.randomElement()!)
    }
    
    static let Example = PlannerView.ViewModel(
        allowed: 3,
        publisher: nil,
        plannedAt: { _ in randomPlanned() },
        isFull: { false },
        add: { print("add", $0, $1) },
        importReminder: { print("import reminder", $0, $1) },
        remove: { print("remove", $0)},
        start: {})
}

// MARK: - Preview

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView(viewModel: .Example)
            .frame(width: 380, height: 610)
    }
}

#endif

// MARK: - Publishers: Keyboard Watching

#if os(iOS)
fileprivate extension Publishers {
    // many thanks to "Yet another Swift Blog" for this approach
    // https://www.vadimbulavin.com/how-to-move-swiftui-view-when-keyboard-covers-text-field/
    static var showingKeyboard: AnyPublisher<Bool, Never> {

        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight > 0 }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in false }
        

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

fileprivate extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
#endif
