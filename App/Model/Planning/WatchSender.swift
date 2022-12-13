//
//  WatchSender.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity
import Combine

final class WatchSender: NSObject {
    
    private var session: WCSession { WCSession.default }
    
    let watchUpdatedPlan = PassthroughSubject<Plan, Never>()
    
    private func startConnection() -> Bool {
        guard WCSession.isSupported() else { return false }
        if session.delegate !== self { // make sure that this hasn't already been called
        
            session.delegate = self
            session.activate()
        }
        return canTalkToWatch
    }
    
    var canTalkToWatch: Bool { session.isPaired && session.isWatchAppInstalled }

    func send(_ planner: Planner) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(planner) else { return }
        let payload = [ModelConstants.WatchConnectivityPlanKey: encoded]
        if startConnection() {
            try? session.updateApplicationContext(payload)
            print("Sent.........")
            print(planner)
        }
    }
}

// MARK: -

extension WatchSender: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(#function)
        print(activationState == .activated ? "activated" : "not activated")
        print(error ?? "no error")
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(#function)
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print(#function)
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print(#function)
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print(#function)
    }
    #endif
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(#function)
        print("Received......\(Date())")
        print(message)
        
        guard let data = message[ModelConstants.WatchConnectivityPlanKey] as? Data,
        let plan = try? JSONDecoder().decode(Plan.self, from: data)
        else { return }
        
        print(plan)
        
        watchUpdatedPlan.send(plan)
        
        replyHandler(["got it":true])
    }
}
