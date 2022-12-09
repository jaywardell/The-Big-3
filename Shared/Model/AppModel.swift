//
//  AppModel.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/17/22.
//

import Foundation
import Combine

final class AppModel {
    // NOTE: callbacks use unowned self because this class should live the life of the app,
    // so a call to a subscription when self is nil is a bug and should be caught immediately
    
    let planner: Planner
    let archiver: PlanArchiver
    let logger: CompletionLog
    
    // NOTE: not using a Set because we want to subscribe to one Plan's publisher at a time
    private var plannerChanged: AnyCancellable?
    private var planChanged: AnyCancellable?

    init() {
        self.archiver = PlanArchiver()
        let loadedPlan = self.archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: loadedPlan)
        
        let archiver = MockCompletionLogArchive(exampleDate: [
            Date(): "get up",
            Date().addingTimeInterval(2*3600): "get out of bed",
            Date().addingTimeInterval(3*3600): "drag a comb across my head",
            Date().addingTimeInterval(24*3600): "go outside and have a smoke"
        ])
        self.logger = CompletionLog(archive: archiver)
        
        plannerChanged = planner.objectWillChange.sink { [unowned self] _ in
            planWasUpdated()
        }
        
        planWasUpdated()
    }
    
    private func planWasUpdated() {
        let plan = planner.plan
        self.archiver.archive(plan)
        planChanged = plan.publisher.sink { [unowned self] in
            planWasUpdated()
        }
    }
}
