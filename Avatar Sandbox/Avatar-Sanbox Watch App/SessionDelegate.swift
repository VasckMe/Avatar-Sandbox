//
//  SessionDelegate.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 28.01.24.
//

import Combine
import SwiftUI
import WatchConnectivity

final class SessionDelegater: NSObject, WCSessionDelegate {
    let imageSubject: PassthroughSubject<UIImage, Never>
    
    let avatarStatsSubject: PassthroughSubject<AvatarWatchModel, Never>
    
    init(
        imageSubject: PassthroughSubject<UIImage, Never>,
        avatarStatsSubject: PassthroughSubject<AvatarWatchModel, Never>
    ) {
        self.imageSubject = imageSubject
        self.avatarStatsSubject = avatarStatsSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Error during activation: \(error)")
        } else {
            print("activationDidCompleteWith: \(activationState)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            guard
                let age = message["age"] as? Int,
                let height = message["height"] as? Float,
                let weight = message["weight"] as? Float
            else {
                print("There was an error with decoding")
                return
            }

            self.avatarStatsSubject.send(AvatarWatchModel(age: age, height: height, weight: weight))
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            guard let image = UIImage(data: messageData) else {
                print("There was an error with casting Data in UIImage")
                return
            }
            self.imageSubject.send(image)
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
}
