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
        let add: (Planned, Int)->()
        let remove: (Int)->()

        private var bag = Set<AnyCancellable>()
        init(allowed: Int,
             publisher: AnyPublisher<Void, Never>?,
             plannedAt: @escaping (Int)->Planned?,
             add: @escaping (Planned, Int)->(),
             remove: @escaping (Int)->()) {
            self.allowed = allowed
            self.plannedAt = plannedAt
            self.add = add
            self.remove = remove
            
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
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34),
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34),
        Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34)
    ]
}

extension PlannerView: View {
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        if let planned = viewModel.plannedAt(index) {
            HStack {
                Text(planned.title)
                    .font(.largeTitle)
                    .shadow(radius: 15)

                Button(action: { userTappedDeleteGoal(at: index) }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.largeTitle).imageScale(.large)
                }
                .buttonStyle(.borderless)
                .shadow(radius: 15)
            }

        }
        else if index == selectedIndex {
            TextField("enter a goal for the day", text: $newPlannedTitle)
                .focused($isFocused)
                .foregroundColor(.primary)
                .background(Color(nsColor: .textBackgroundColor))
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
            .shadow(radius: 15)

        }
        else {
            // to ensure spacing
            HStack {}
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(0...viewModel.allowed-1, id: \.self) { index in
                
                planBlock(at: index)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Rectangle().fill(colors[index])
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func userTappedEmptyPlannedBlock(at index: Int) {
        selectedIndex = index

        print(#function, index)
    }

    private func userTappedDeleteGoal(at index: Int) {
        viewModel.remove(index)
    }
    
    private func userEnteredNewPlannedTitle(_ newPlannedTitle: String, at index: Int) {
        print(#function, index)
        
        viewModel.add(ViewModel.Planned(title: newPlannedTitle), index)
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
        add: { print("add", $0, $1) },
        remove: { print("remove", $0)})
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView(viewModel: .Example)
            .frame(width: 380, height: 610)
    }
}

#endif
