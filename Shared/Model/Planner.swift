//
//  Planner.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/8/22.
//

import Foundation

final class Planner: ObservableObject {
    
    @Published var plan = Plan(allowed: 3)
}
