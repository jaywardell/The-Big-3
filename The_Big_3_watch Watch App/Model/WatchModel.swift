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
    private var userCompletedGoal: AnyCancellable?

    init() {
        let plan = archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: plan)
        
        self.phoneSentPlan = watchSynchronizer.receivedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: takePlannerFromSynchronizer)
        self.plannerChanged = planner.objectWillChange.sink(receiveValue: plannerWasUpdated)
        self.planChanged = plan.publisher.sink(receiveValue: planWasUpdated)
        
        self.userCompletedGoal = NotificationCenter.default.publisher(for: Plan.GoalWasCompleted)
            .compactMap { $0.userInfo?[Plan.GoalKey] as? String }
            .map { Plan.Goal(title: $0, state: .completed) }
            .sink(receiveValue: watchSynchronizer.send(completedGoal:))
    }
    
    
    private func takePlannerFromSynchronizer(_ planner: Planner) {
        self.planner = planner
        plannerChanged = planner.objectWillChange.sink(receiveValue: plannerWasUpdated)
        planChanged = planner.plan.publisher.sink(receiveValue: planWasUpdated)

        archiver.archive(planner.plan)
    }
    
    private func plannerWasUpdated() {
        let plan = planner.plan
        archiver.archive(plan)
        
        watchSynchronizer.send(plan: plan)
        
        planChanged = plan.publisher.sink(receiveValue: planWasUpdated)
    }

    private func planWasUpdated() {
        planner.objectWillChange.send()
    }
}
