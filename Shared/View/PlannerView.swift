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
        let remove: (Int)->()
        let start: ()->()

        private var bag = Set<AnyCancellable>()
        init(allowed: Int,
             publisher: AnyPublisher<Void, Never>?,
             plannedAt: @escaping (Int)->Planned?,
             isFull: @escaping ()->Bool,
             add: @escaping (Planned, Int)->(),
             remove: @escaping (Int)->(),
             start: @escaping ()->()) {
            
            self.allowed = allowed
            self.plannedAt = plannedAt
            self.isFull = isFull
            self.add = add
            self.remove = remove
            self.start = start
            
            publisher?.sink { [weak self] in
                self?.objectWillChange.send()
            }
            .store(in: &bag)
        }
    }
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedIndex: Int?
    @State private var newPlannedTitle: String = ""
    
    @FocusState private var isFocused: Bool

    let colors = [
        Color(hue: 1/2, saturation:21/34, brightness: 26/34),
        Color(hue: 5/8, saturation:21/34, brightness: 26/34),
        Color(hue: 3/4, saturation:21/34, brightness: 26/34)
    ]
}

// MARK: - PlannerView: View

extension PlannerView: View {
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        if let planned = viewModel.plannedAt(index) {
            HStack {
                
                Spacer()
                
                Text(planned.title)
                    .font(.system(size: 1000, weight: .light, design: .serif))
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.01)
                    .shadow(radius: 15)

                Spacer()
                
                VStack {
                    Spacer()
                    Button(action: { userTappedDeleteGoal(at: index) }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.largeTitle).imageScale(.large)
                    }
                    .buttonStyle(.borderless)
                    .accentColor(.white)
                   .shadow(radius: 15)
                }
            }
            .padding()
        }
        else if index == selectedIndex {
            TextField("enter a goal for the day", text: $newPlannedTitle)
                .focused($isFocused)
                .font(.largeTitle)
                .foregroundColor(.white)
                .onAppear { isFocused = true }
                .onSubmit {
                    userEnteredNewPlannedTitle(newPlannedTitle, at: index)
                    newPlannedTitle = ""
                    selectedIndex = nil
                }
                .padding()
        }
        else if index == 0 || viewModel.plannedAt(index-1) != nil {
            Button(action: { userTappedEmptyPlannedBlock(at: index) }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle).imageScale(.large)
            }
            .buttonStyle(.borderless)
            .accentColor(.white)
            .shadow(radius: 15)

        }
        else {
            // to ensure spacing
            HStack {}
        }
    }
    
    private var startButton: some View {
        Button(action: viewModel.start) {
            Text("Start")
                .font(.largeTitle)
                .bold()
                .minimumScaleFactor(0.01)
                .padding()
        }
        .buttonStyle(.borderless)
    }
    
    @ViewBuilder private func background(at index: Int) -> some View {
        
        let colors = [ colors[index], colors[index].opacity(13/34)  ]
        RadialGradient(colors: colors, center: .center, startRadius: 0, endRadius: 1000)
    }

    var body: some View {
        TitledWithToolbar("What are the Big 3?") {
            
            
            VStack(spacing: 0) {
                ForEach(0...viewModel.allowed-1, id: \.self) { index in
                    
                    planBlock(at: index)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(background(at: index)
                        )
                }
            }
        } toolbar: {
            Button(action: viewModel.start) {
                Text("Start")
            }
            .opacity(viewModel.isFull() ? 1 : 0)
        }
    }
        
    private func userTappedEmptyPlannedBlock(at index: Int) {
        selectedIndex = index

        print(#function, index)
    }

    private func userTappedDeleteGoal(at index: Int) {
        withAnimation {
        viewModel.remove(index)
        }
    }
    
    private func userEnteredNewPlannedTitle(_ newPlannedTitle: String, at index: Int) {
        print(#function, index)
        withAnimation {
        viewModel.add(ViewModel.Planned(title: newPlannedTitle), index)
        }
    }
}

// MARK: -

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
        remove: { print("remove", $0)},
        start: {})
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView(viewModel: .Example)
            .frame(width: 380, height: 610)
    }
}

#endif
