//
//  ModelConstants.swift
//  The_Big_3_WidgetsExtension
//
//  Created by Joseph Wardell on 12/11/22.
//

import Foundation

enum ModelConstants {
    static var allowedGoalsPerPlan: Int { 3 }
    
    static var WatchConnectivityPlanKey: String { #function }
    static var WatchConnectivityCompletedGoalKey: String { #function }
    
    // NOTE: the file referenced here isn't included in this repo.
    // You will need to set up a new app group associated with your provisioning profile
    // in App Store Connect.
    // (see https://developer.apple.com/documentation/xcode/configuring-app-groups)
    //
    // and then paste the group id into a file called "group_id.txt"
    // which you then set to be copied into your bundle's resources.
    // (the App/Model/Resources directory is set up for this)
    // you will also have to change the group id
    // in the app target's "Signing & Capabilities" tab
    // and also in the widget target's "Signing & Capabilities"
    // to the group id you created.
    static var appGroup: String {
        let fileURL = Bundle.main.url(forResource: "group_id", withExtension: "txt")!
        return try! String(contentsOf: fileURL).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
}
