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
}

extension PlannerView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(1...viewModel.allowed, id: \.self) { _ in
                Rectangle().fill(Color(hue: CGFloat.random(in: 0...1), saturation:CGFloat.random(in: 0...1), brightness: 1))
            }
        }
    }
}

#if DEBUG

extension PlannerView.ViewModel {
    
    static var ExamplePlan: [PlannerView.ViewModel.Planned] = []
    
    static let Example = PlannerView.ViewModel(
        allowed: 3,
        plannedAt: { _ in nil },
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
