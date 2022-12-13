//
//  WatchSynchronizer.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity
import Combine

final class WatchSynchronizer: NSObject {
        
    var receivedPlan = PassthroughSubject<Plan, Never>()
    
    private var session: WCSession { WCSession.default }

    override init() {
        super.init()
        if startConnection() {
            
            // try to load any plan that was sent
            // since the last time we were loaded
            if let encoded = session.receivedApplicationContext[ModelConstants.WatchConnectivityPlanKey] as? Data {
                if let plan = try? JSONDecoder().decode(Plan.self, from: encoded) {
                    receivedPlan.send(plan)
                }
            }
        }
    }
    
    private func startConnection() -> Bool {
        guard WCSession.isSupported() else { return false }
        if session.delegate !== self { // make sure that this hasn't already been called
        
            session.delegate = self
            session.activate()
        }
        return true
    }

    func send(_ plan: Plan) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(plan) else { return }
        let payload = [ModelConstants.WatchConnectivityPlanKey: encoded]
        if startConnection() {
            session.sendMessage(payload, replyHandler: { reply in
                print(reply)
            }, errorHandler: { error in
                print(error)
            })
            print("Sent.........")
            print(plan)
        }
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
        
        print("Received.................\t\(Date())")
        print(plan)
        
        receivedPlan.send(plan)
    }
}
