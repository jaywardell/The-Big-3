//
//  PlanArchiver.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/16/22.
//

import Foundation

struct PlanArchiver {
    
    private var defaults: UserDefaults {
        UserDefaults(suiteName: ModelConstants.appGroup)!
    }
    
    func loadPlan(allowed: Int) -> Plan {
        var out = defaults.latestPlan
        out = out?.allowed == allowed ? out : nil
        return out ?? Plan(allowed: allowed)
    }
    
    func archive(_ plan: Plan) {
        defaults.latestPlan = plan
    }
    
}

extension UserDefaults {
    private static var Plan_Key: String { #function }

    var latestPlan: Plan? {
        get {
            codable(forKey: Self.Plan_Key)
        }

        set {
            setCodable(newValue, forKey: Self.Plan_Key)
        }
    }
}
