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
    
    init() {
        let plan = archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: plan)
        phoneSentPlan = watchSynchronizer.receivedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: takePlanFromSynchronizer)
    }
    
    
    private func takePlanFromSynchronizer(_ plan: Plan) {
        print(#function)
        print("Updated............\t\(Date())")
        print(plan)
        self.planner = Planner(plan: plan)
        
        archiver.archive(plan)
    }
}
