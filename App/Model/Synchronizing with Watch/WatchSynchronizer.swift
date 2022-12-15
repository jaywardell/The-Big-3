//
//  WatchSender.swift
//  The Big 3 (iOS)
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity
import Combine

/// Use this class to send and receive messages to the companion app on the watch, if any
final class WatchSynchronizer: NSObject {
    
    private var session: WCSession { WCSession.default }
    
    let watchUpdatedPlan = PassthroughSubject<Plan, Never>()
    let watchCompletedGoal = PassthroughSubject<Plan.Goal, Never>()

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
        guard let payload = try? Dictionary(ModelConstants.WatchConnectivityPlanKey, planner) else { return }
        if startConnection() {
            try? session.updateApplicationContext(payload)
        }
    }
}

// MARK: -

extension WatchSynchronizer: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
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
        let positiveReply = ["got it":true]
        
        if receiveUpdatedPlan(from: message) {
            replyHandler(positiveReply)
        }
        else if receiveCompletedGoal(from: message) {
            replyHandler(positiveReply)
        }
    }
    
    private func receiveUpdatedPlan(from dictionary: [String: Any]) -> Bool {
        guard let plan: Plan = dictionary.decode(ModelConstants.WatchConnectivityPlanKey) else { return false }
                
        watchUpdatedPlan.send(plan)
        return true
    }
    
    private func receiveCompletedGoal(from dictionary: [String: Any]) -> Bool {
        guard let goal: Plan.Goal = dictionary.decode(ModelConstants.WatchConnectivityCompletedGoalKey),
              goal.state == .completed
        else { return false }
        
        watchCompletedGoal.send(goal)
        return true
    }
}

