//
//  PlanArchiver.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/16/22.
//

import Foundation

struct PlanArchiver {
    
    let shared: Bool
    
    init(shared: Bool) {
        self.shared = shared
    }
    
    private var defaults: UserDefaults {
        shared ? UserDefaults(suiteName: ModelConstants.appGroup)! : UserDefaults.standard
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

    fileprivate var latestPlan: Plan? {
        get {
            synchronize()
            return codable(forKey: Self.Plan_Key)
        }

        set {
            setCodable(newValue, forKey: Self.Plan_Key)
            synchronize()
        }
    }
}
