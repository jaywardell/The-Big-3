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
        
    var receivedPlan = PassthroughSubject<Planner, Never>()
    
    private var session: WCSession { WCSession.default }

    override init() {
        super.init()
        if startConnection() {
            
            // try to load any plan that was sent
            // since the last time we were loaded
            // honestly, I don't think this ever happens...
            if let encoded = session.receivedApplicationContext[ModelConstants.WatchConnectivityPlanKey] as? Data {
                if let planner = try? JSONDecoder().decode(Planner.self, from: encoded) {
                    receivedPlan.send(planner)
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

    func send(plan: Plan) {
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

    func send(completedGoal goal: Plan.Goal) {
        assert(goal.state == .completed)
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(goal) else { return }
        let payload = [ModelConstants.WatchConnectivityCompletedGoalKey: encoded]
        if startConnection() {
            session.sendMessage(payload, replyHandler: { reply in
                print(reply)
            }, errorHandler: { error in
                print(error)
            })
            print("Sent.........")
            print(goal)
        }
    }

    private func receiveUpdatedPlanner(from dictionary: [String : Any]) -> Bool {
        guard let encoded = dictionary[ModelConstants.WatchConnectivityPlanKey] as? Data,
              let planner = try? JSONDecoder().decode(Planner.self, from: encoded) else { return false }
        
        print("Received.................\t\(Date())")
        print(planner)
        
        receivedPlan.send(planner)
        return true
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

        _ = receiveUpdatedPlanner(from: applicationContext)
    }
}
