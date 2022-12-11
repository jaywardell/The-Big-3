//
//  WidgetModel.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation

final class WidgetModel {
        
    var planner: Planner {
        let loadedPlan = PlanArchiver().loadPlan(allowed: 3)
        return Planner(plan: loadedPlan)
    }
}
