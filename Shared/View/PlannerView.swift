//
//  PlannerView.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import SwiftUI

struct PlannerView {
    
    final class ViewModel: ObservableObject {
        struct Planned {
            let title: String
        }

        let allowed: Int

        let plannedAt: (Int)->Planned?
        let add: (Planned, Int)->()
        let remove: (Int)->()

        init(allowed: Int,
             plannedAt: @escaping (Int)->Planned?,
             add: @escaping (Planned, Int)->(),
             remove: @escaping (Int)->()) {
            self.allowed = allowed
            self.plannedAt = plannedAt
            self.add = add
            self.remove = remove
        }
    }
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedIndex: Int?
    @State private var newPlannedTitle: String = ""
}

extension PlannerView: View {
    
    @ViewBuilder private func planBlock(at index: Int) -> some View {
        if let planned = viewModel.plannedAt(index) {
            Text(planned.title)
                .font(.largeTitle)
        }
        else if index == selectedIndex {
            TextField("enter a goal for the day", text: $newPlannedTitle)
                .onSubmit {
                    userEnteredNewPlannedTitle(newPlannedTitle, at: index)
                    newPlannedTitle = ""
                    selectedIndex = nil
                }
        }
        else {
            Button(action: { userTappedEmptyPlannedBlock(at: index) }) {
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle).imageScale(.large)
            }
            .buttonStyle(.borderless)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1...viewModel.allowed, id: \.self) { index in
                
                planBlock(at: index)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        Rectangle().fill(Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 26/34))
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func userTappedEmptyPlannedBlock(at index: Int) {
        selectedIndex = index

        print(#function, index)
    }
    
    private func userEnteredNewPlannedTitle(_ newPlannedTitle: String, at index: Int) {
        print(#function, index)
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
