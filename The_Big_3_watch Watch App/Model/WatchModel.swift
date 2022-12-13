//
//  WatchModel.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import Combine

final class WatchModel: ObservableObject {
    

    @Published var planner: Planner

    // used to communicate with the phone app
    let watchSynchronizer = WatchSynchronizer()

    // used to store the most recent plan between launches
    let archiver = PlanArchiver(shared: false)
    
    private var phoneSentPlan: AnyCancellable!
    private var plannerChanged: AnyCancellable?
    private var planChanged: AnyCancellable?

    init() {
        let plan = archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: plan)
        
        phoneSentPlan = watchSynchronizer.receivedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: takePlannerFromSynchronizer)
        plannerChanged = planner.objectWillChange.sink(receiveValue: planWasUpdated)
        planChanged = plan.publisher.sink(receiveValue: planWasUpdated)
    }
    
    
    private func takePlannerFromSynchronizer(_ planner: Planner) {
        print(#function)
        print("Updated............\t\(Date())")
        print(planner)
        self.planner = planner
        
        archiver.archive(planner.plan)
    }
    
    private func planWasUpdated() {
        let plan = planner.plan
        archiver.archive(plan)
        
        watchSynchronizer.send(plan)
        
        planChanged = plan.publisher.sink { [unowned self] in
            planWasUpdated()
        }
    }

}
