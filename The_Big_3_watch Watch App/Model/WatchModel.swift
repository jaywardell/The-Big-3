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

    let archiver = PlanArchiver()
    
    init() {
        let plan = archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: plan)
        watchSynchronizer.receivedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: takePlanFromSynchronizer)
            .store(in: &subscriptions)
    }
    
    
    private func takePlanFromSynchronizer(_ plan: Plan) {
        print(#function)
        print("Updated............\t\(Date())")
        print(plan)
        self.planner = Planner(plan: plan)
        
        archiver.archive(plan)
    }
}
