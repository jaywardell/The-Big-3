//
//  Planner+GraphicSummary.swift
//  The Big 3
//
//  Created by Joseph Wardell on 12/14/22.
//

import Foundation

extension Planner {
    
    func graphicSummaryViewModel() -> GraphicSummary.ViewModel {
        .init(total: plan.allowed, todoAt: todo(at:))
    }
}
