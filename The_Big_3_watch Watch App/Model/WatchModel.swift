//
//  WatchModel.swift
//  The_Big_3_Watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation

final class WatchModel {
    
    var planner: Planner {
        let loadedPlan = PlanArchiver().loadPlan(allowed: 3)
        return Planner(plan: loadedPlan)
    }
}
