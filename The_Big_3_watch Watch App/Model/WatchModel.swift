//
//  WatchModel.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import Combine

final class WatchModel: ObservableObject {
    
//    let planChanged: AnyCancellable!
    private var subscriptions = Set<AnyCancellable>()
    let watchSynchronizer = WatchSynchronizer()

    @Published var planner: Planner
//    {
//        let loadedPlan = PlanArchiver().loadPlan(allowed: 3)
//        return Planner(plan: loadedPlan)
//    }

    init() {
        self.planner = Planner(plan: Plan())
        watchSynchronizer.objectWillChange.sink(receiveValue: takePlanFromSynchronizer)
            .store(in: &subscriptions)
    }
    
    
    private func takePlanFromSynchronizer() {
        guard let newPlan = watchSynchronizer.sentPlan else { return }
        self.planner = Planner(plan: newPlan)
    }
}
