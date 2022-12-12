//
//  WatchSender.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity

final class WatchSender: NSObject {
    
    private var session: WCSession { WCSession.default }
    
    private func startConnection(_ callback: () throws ->()) throws {
        guard WCSession.isSupported() else { return }
        if session.delegate !== self { // make sure that this hasn't already been called
        
            session.delegate = self
            session.activate()
        }
        guard canTalkToWatch else { return }
        
        try callback()
    }
    
    var canTalkToWatch: Bool { session.isPaired && session.isWatchAppInstalled }

    func send(_ plan: Plan) {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(plan) else { return }
        let payload = [ModelConstants.WatchConnectivityPlanKey: encoded]
        try? startConnection {
            try? session.updateApplicationContext(payload)
            print("Sent.........")
            print(plan)
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
}
