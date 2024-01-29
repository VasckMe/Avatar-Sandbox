//
//  AvatarWatchViewModel.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 28.01.24.
//

import Combine
import WatchConnectivity
import SwiftUI

final class AvatarWatchViewModel: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
        
    let imageSubject = PassthroughSubject<UIImage, Never>()
    let avatarStatsSubject = PassthroughSubject<AvatarWatchModel, Never>()
    
    @Published var avatarStats = AvatarWatchModel(age: 0, height: 0, weight: 0)
    @Published var image: UIImage = UIImage()
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(
            imageSubject: imageSubject,
            avatarStatsSubject: avatarStatsSubject
        )
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        avatarStatsSubject
            .assign(to: &$avatarStats)
        imageSubject
            .assign(to: &$image)
    }
    
    func sync() {
        if (session.isReachable) {
            let message = [
                "age": avatarStats.age,
                "height": avatarStats.height,
                "weight": avatarStats.weight
            ] as [String : Any]
            
            WCSession.default.sendMessage(message, replyHandler: nil)
        } else {
            print("Session is not reachable")
        }
    }
}
