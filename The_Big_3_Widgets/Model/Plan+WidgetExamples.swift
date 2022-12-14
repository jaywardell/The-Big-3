//
//  Plan+WidgetExamples.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation

extension Plan {
    
    static var widgetPlaceholderExample: Plan {
        let plan = Plan(allowed: 3)
        try! plan.set("Read", at: 0)
        try! plan.set("Buy Groceries", at: 1)
        try! plan.set("Call Mom", at: 2)

        try! plan.completeGoal(at: 0)
        try! plan.deferGoal(at: 2)

        return plan
    }
    
}
