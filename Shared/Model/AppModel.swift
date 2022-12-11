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
    var logger: CompletionLog
    
    let eventKitReminderUpdater = ExternalGoalServiceUpdater(bridge: EventKitGoalService())
    
    // NOTE: not using a Set because we want to subscribe to one Plan's publisher at a time
    private var plannerChanged: AnyCancellable?
    private var planChanged: AnyCancellable?
    private var userCompletedGoal: AnyCancellable?
    
    init() {
        self.archiver = PlanArchiver()
        let loadedPlan = self.archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: loadedPlan)
        
        let archiver = JSONCompletionLogArchive()
        self.logger = CompletionLog(archive: archiver)
        
        plannerChanged = planner.objectWillChange.sink { [unowned self] _ in
            planWasUpdated()
        }
        
        userCompletedGoal = NotificationCenter.default.publisher(for: Plan.GoalWasCompleted).sink { notification in
            guard let goalString = notification.userInfo?[Plan.GoalKey] as? String else { return }
            let goal = Plan.Goal(title: goalString, state: .completed)
            Task {
                do {
                    try await self.logger.log(goal)
                }
                catch {
                    print("Error logging completion of goal \"\(goal)\": \(error)")
                }
            }
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
