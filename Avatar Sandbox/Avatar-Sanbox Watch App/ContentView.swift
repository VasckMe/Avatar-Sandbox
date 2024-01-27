//
//  ContentView.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 27.01.24.
//

import SwiftUI
import WatchConnectivity

struct CharacterStatsView: View {
    var age: Int
    var height: Int
    var weight: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Age")
                Text("\(age)")
            }
            HStack {
                Text("Height")
                Text("\(height)")
            }
            HStack {
                Text("Weight")
                Text("\(weight)")
            }
        }
        .frame(alignment: .leading)
    }
}

struct ContentView: View {

    @StateObject var counter = Counter()

    var body: some View {
        ZStack {
//            Color(.white)
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(.clear)
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        .shadow(color: .black, radius: 5)
                        .frame(width: 100, height: 100)
                    Image(uiImage: counter.model?.image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
                CharacterStatsView(
                    age: counter.model?.age ?? 0,
                    height: counter.model?.age ?? 0,
                    weight: counter.model?.age ?? 0
                )
//                    Color(.purple)
                //            Text("\(counter.count)")
                //                .font(.largeTitle)
                
                //            HStack {
                //                Button(action: counter.decrement) {
                //                    Label("Decrement", systemImage: "minus.circle")
                //                }
                //                .padding()
                //
                //                Button(action: counter.increment) {
                //                    Label("Increment", systemImage: "plus.circle.fill")
                //                }
                //                .padding()
                //            }
                //            .font(.headline)
                //            .labelStyle(labelStyle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class SessionDelegater: NSObject, WCSessionDelegate {
    let countSubject: PassthroughSubject<Int, Never>
    let countSubj: PassthroughSubject<CharacterModel?, Never>
    
    init(countSubject: PassthroughSubject<Int, Never>, countSubj: PassthroughSubject<CharacterModel?, Never>) {
        self.countSubject = countSubject
        self.countSubj = countSubj
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Protocol comformance only
        // Not needed for this demo
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            let model = message["model"] as? CharacterModel
            self.countSubj.send(model)
//            print(message["message"] as? String)
//            if let count = message["message"] as? Int {
//                self.countSubject.send(count)
//            } else {
//                print("There was an error")
//            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("receiving data")
    }
    
    // iOS Protocol comformance
    // Not needed for this demo otherwise
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("\(#function): activationState = \(session.activationState.rawValue)")
    }
    #endif
}

import Combine
import WatchConnectivity

public struct CharacterModel {
    let image: UIImage
    let age: Int
    let height: Int
    let weight: Int
}

final class Counter: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    
    let subj = PassthroughSubject<CharacterModel?, Never>()
    let subject = PassthroughSubject<Int, Never>()
    
    @Published private(set) var model: CharacterModel?
    @Published private(set) var count: Int = 0
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject, countSubj: subj)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
        subj
            .assign(to: &$model)
    }
    
    func increment() {
        count += 1
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func decrement() {
        count -= 1
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}
