//
//  WatchModel.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import Combine

final class WatchModel: ObservableObject {
    
    private var subscriptions = Set<AnyCancellable>()
    let watchSynchronizer = WatchSynchronizer()

    @Published var planner: Planner

    init() {
        self.planner = Planner(plan: Plan(allowed: 3))
        watchSynchronizer.objectWillChange.sink(receiveValue: takePlanFromSynchronizer)
            .store(in: &subscriptions)
    }
    
    
    private func takePlanFromSynchronizer() {
        guard let newPlan = watchSynchronizer.sentPlan else { return }
        print(newPlan)
        self.planner = Planner(plan: newPlan)
    }
}
