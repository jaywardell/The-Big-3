//
//  ModelConstants.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation

enum ModelConstants {
    static var allowedGoalsPerPlan: Int { 3 }
    
    // NOTE: if you try to use this module with any provisioning profile other than the author's
    // it will not work.
    // You will need to set up a new app group associated with your provisioning profile
    // in App Store Connect.
    // see https://developer.apple.com/documentation/xcode/configuring-app-groups
    static var appGroup: String { "group.com.oldjewel.TheBig3" }
}
