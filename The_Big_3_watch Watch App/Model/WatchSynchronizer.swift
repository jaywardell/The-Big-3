//
//  WatchSynchronizer.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity
import Combine

final class WatchSynchronizer: NSObject, ObservableObject {
    
    @Published var sentPlan: Plan?
    
    private var session: WCSession { WCSession.default }

    private func startConnection(_ callback: () throws ->()) throws {
        guard WCSession.isSupported() else { return }
        if session.delegate !== self { // make sure that this hasn't already been called
        
            session.delegate = self
            session.activate()
        }
        
        try callback()
    }

    override init() {
        super.init()
        try! startConnection {}
    }
}


extension WatchSynchronizer: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(#function)
        print(activationState == .activated ? "activated" : "not activated")
        print(error ?? "no error")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(#function)

        guard let encoded = applicationContext[ModelConstants.WatchConnectivityPlanKey] as? Data,
              let plan = try? JSONDecoder().decode(Plan.self, from: encoded) else { return }
        
        sentPlan = plan
    }
}
