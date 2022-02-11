//
//  Planner.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation
import Combine

final class Planner: ObservableObject {
        
    enum State { case planning, doing }
    
    @Published var state: State = .planning
    
    let plan: Plan
    
    init(_ plan: Plan = Plan(allowed: 3)) {
        self.plan = plan
    }
}
