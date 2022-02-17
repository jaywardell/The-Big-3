//
//  AppModel.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/17/22.
//

import Foundation
import Combine

final class AppModel {
    
    let planner: Planner
    let archiver: PlanArchiver
    
    private var bag = Set<AnyCancellable>()
    
    init() {
        self.archiver = PlanArchiver()
        let loadedPlan = self.archiver.loadPlan(allowed: 3)
        self.planner = Planner(plan: loadedPlan)
        
        planner.objectWillChange.sink { [unowned self] _ in
            planWasUpdated()
        }
        .store(in: &bag)
    }
    
    private func planWasUpdated() {
        self.archiver.archive(planner.plan)
    }
}
