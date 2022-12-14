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
    let watchSynchronizer: WatchSynchronizer
    var logger: CompletionLog
    
    let eventKitReminderUpdater = ExternalGoalServiceUpdater(bridge: EventKitGoalService())
    
    private var remindersWatcher: EventKitReminderWatcher!
    
    // NOTE: not using a Set because we want to subscribe to one Plan's publisher at a time
    private var plannerChanged: AnyCancellable?
    private var planChanged: AnyCancellable?
    private var userCompletedGoal: AnyCancellable?
    private var watchChangedPlan: AnyCancellable?
    private var watchCompletedGoal: AnyCancellable?

    init() {
        self.archiver = PlanArchiver(shared: true)
        let loadedPlan = self.archiver.loadPlan(allowed: ModelConstants.allowedGoalsPerPlan)
        self.planner = Planner(plan: loadedPlan)
        
        self.logger = CompletionLog(archive: JSONCompletionLogArchive())
        
        self.watchSynchronizer = WatchSynchronizer()
        
        self.remindersWatcher = EventKitReminderWatcher(reminderWasCompleted: remindersAppCompletedReminderWith(identifier:), reminderWasDeleted: remindersAppDeletedReminderWith(identifier:))

        self.plannerChanged = planner.objectWillChange.sink(receiveValue: planWasUpdated)
        
        self.userCompletedGoal = NotificationCenter.default.publisher(for: Plan.GoalWasCompleted)
            .compactMap { $0.userInfo?[Plan.GoalKey] as? String }
            .map { Plan.Goal(title: $0, state: .completed) }
            .sink(receiveValue: log(goalCompleted:))
        
        self.watchChangedPlan = watchSynchronizer.watchUpdatedPlan
            .receive(on: RunLoop.main)
            .sink(receiveValue: updatePlanner(with:))
        
        self.watchCompletedGoal = watchSynchronizer.watchCompletedGoal
            .receive(on: RunLoop.main)
            .sink(receiveValue: log(goalCompleted:))

        planWasUpdated()
    }
    
    private func planWasUpdated() {
        let plan = planner.plan
        archiver.archive(plan)
        
        // this is received BEFORE the planner is updated,
        // so we need a delay to make sure that
        // we send the right info
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.watchSynchronizer.send(self.planner)
        }
        
        remindersWatcher.watchForChangesInRemindersWith(ids: plan.currentGoals.compactMap(\.?.externalIdentifier))
        
        // in case the plan somehow was changed
        planChanged = plan.publisher.sink(receiveValue: planWasUpdated)

        WidgetCenter.shared.reloadAllTimelines()
    }
    
    private func updatePlanner(with plan: Plan) {
        planner.plan = plan
        
        planWasUpdated()
    }
    
    private func remindersAppCompletedReminderWith(identifier id: String) {
        planner.completeGoalWith(externalIdentifier: id)
    }
    
    private func remindersAppDeletedReminderWith(identifier id: String) {
        planner.deleteGoalWith(externalIdentifier: id)
    }
        
    private func log(goalCompleted goal: Plan.Goal) {
        assert(goal.state == .completed)
        
        Task { [unowned self] in
            do {
                try await self.logger.log(goal)
            }
            catch {
                print("Error logging completion of goal \"\(goal)\": \(error)")
            }
        }
    }
}
