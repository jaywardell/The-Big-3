//
//  PlanArchiver.swift
//  The Big 3
//
//  Created by Joseph Wardell on 2/16/22.
//

import Foundation

final class PlanArchiver {
    
    func loadPlan(allowed: Int) -> Plan {
        var out = UserDefaults.standard.latestPlan
        out = out?.allowed == allowed ? out : nil
        return out ?? Plan(allowed: allowed)
    }
    
    func archive(_ plan: Plan) {
        UserDefaults.standard.latestPlan = plan
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
