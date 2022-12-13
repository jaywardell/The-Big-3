//
//  AppModel.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/17/22.
//

import Foundation
import Combine
import WidgetKit

final class AppModel {
    // NOTE: callbacks use unowned self because this class should live the life of the app,
    // so a call to a subscription when self is nil is a bug and should be caught immediately
    
    let planner: Planner
    let archiver: PlanArchiver
    let watchSender: WatchSender
    var logger: CompletionLog
    
    let eventKitReminderUpdater = ExternalGoalServiceUpdater(bridge: EventKitGoalService())
    
    private var remindersWatcher: EventKitReminderWatcher!
    
    // NOTE: not using a Set because we want to subscribe to one Plan's publisher at a time
    private var plannerChanged: AnyCancellable?
    private var planChanged: AnyCancellable?
    private var userCompletedGoal: AnyCancellable?
    private var watchChangedPlan: AnyCancellable?

    init() {
        self.archiver = PlanArchiver(shared: true)
        let loadedPlan = self.archiver.loadPlan(allowed: ModelConstants.allowedGoalsPerPlan)
        self.planner = Planner(plan: loadedPlan)
        
        let archiver = JSONCompletionLogArchive()
        self.logger = CompletionLog(archive: archiver)
        
        self.watchSender = WatchSender()
        
        self.remindersWatcher = EventKitReminderWatcher(reminderWasCompleted: remindersAppCompletedReminderWith(identifier:), reminderWasDeleted: remindersAppDeletedReminderWith(identifier:))

        self.plannerChanged = planner.objectWillChange.sink { [unowned self] _ in
            planWasUpdated()
        }
        
        self.userCompletedGoal = NotificationCenter.default.publisher(for: Plan.GoalWasCompleted).sink { notification in
            guard let goalString = notification.userInfo?[Plan.GoalKey] as? String else { return }
            let goal = Plan.Goal(title: goalString, state: .completed)
            Task { [unowned self] in
                do {
                    try await self.logger.log(goal)
                }
                catch {
                    print("Error logging completion of goal \"\(goal)\": \(error)")
                }
            }
        }
        
        self.watchChangedPlan = watchSender.watchUpdatedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: updatePlanner(with:))
        
        planWasUpdated()
    }
    
    private func planWasUpdated() {
        let plan = planner.plan
        archiver.archive(plan)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.watchSender.send(self.planner)
        }
        
        remindersWatcher.watchForChangesInRemindersWith(ids: plan.currentGoals.compactMap(\.?.externalIdentifier))
        
        planChanged = plan.publisher.sink { [unowned self] in
            planWasUpdated()
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func updatePlanner(with plan: Plan) {
        planner.plan = plan
    }
    
    private func remindersAppCompletedReminderWith(identifier id: String) {
        planner.completeGoalWith(externalIdentifier: id)
    }
    
    private func remindersAppDeletedReminderWith(identifier id: String) {
        planner.deleteGoalWith(externalIdentifier: id)
    }
}
