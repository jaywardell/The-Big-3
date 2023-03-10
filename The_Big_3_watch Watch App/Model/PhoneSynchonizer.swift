//
//  WatchSynchronizer.swift
//  The_Big_3_watch Watch App
//
//  Created by Joseph Wardell on 12/12/22.
//

import Foundation
import WatchConnectivity
import Combine

/// Use this class to send and receive messages with the host app on the phone
final class PhoneSynchonizer: NSObject {
        
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
        send(plan, for: ModelConstants.WatchConnectivityPlanKey)
    }

    func send(completedGoal goal: Plan.Goal) {
        assert(goal.state == .completed)

        send(goal, for: ModelConstants.WatchConnectivityCompletedGoalKey)
    }
    
    private func send<Value: Encodable>(_ value: Value, for key: String) {
        guard let payload = try? Dictionary(key, value) else { return }
        if startConnection() {
            session.sendMessage(payload, replyHandler: { reply in
                assert(reply as? [String:Bool] == ModelConstants.WatchConnectivitySuccessfulReply)
            }, errorHandler: { error in
                print(error)
            })
        }
    }


    private func receiveUpdatedPlanner(from dictionary: [String : Any]) -> Bool {
        guard let planner: Planner = dictionary.decode(ModelConstants.WatchConnectivityPlanKey) else { return false }
        
        receivedPlan.send(planner)
        
        return true
    }
}


extension PhoneSynchonizer: WCSessionDelegate {
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
