//
//  Planner.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation
import Combine

final class Planner: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    let plan = Plan(allowed: 3)
    
    init() {
        plan.publisher.sink { [weak self] in
            self?.objectWillChange.send()
        }
        .store(in: &bag)
    }
}
