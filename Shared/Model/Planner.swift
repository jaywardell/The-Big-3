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
    
    var plan: Plan
    
    init(plan: Plan = Plan(allowed: 3)) {
        self.plan = plan
        self.state = plan.isFull ? .doing : .planning
    }
}


#if DEBUG
// MARK: -


extension Plan {
    
    static let example: Plan = {
        let out = Plan(allowed: 3)
        
        try! out.set("Do the dishes", at: 0)
        try! out.set("Wash the sink", at: 1)
        try! out.set("Pet the cat", at: 2)
        
        return out
    }()
}
#endif
