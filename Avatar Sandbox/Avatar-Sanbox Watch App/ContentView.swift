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

    @StateObject var model = Model()

    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .foregroundColor(.clear)
                        .overlay(Circle().stroke(Color.white, lineWidth: 5))
                        .shadow(color: .black, radius: 5)
                        .frame(width: 100, height: 100)
                    Image(uiImage: model.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
                CharacterStatsView(
                    age: model.age,
                    height: model.height,
                    weight: model.weight
                )
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
    let ageSubject: PassthroughSubject<Int, Never>
    let heightSubject: PassthroughSubject<Int, Never>
    let weightSubject: PassthroughSubject<Int, Never>
    let imageSubject: PassthroughSubject<UIImage, Never>
    
    init(
        ageSubject: PassthroughSubject<Int, Never>,
        heightSubject: PassthroughSubject<Int, Never>,
        weightSubject: PassthroughSubject<Int, Never>,
        imageSubject: PassthroughSubject<UIImage, Never>
    ) {
        self.ageSubject = ageSubject
        self.heightSubject = heightSubject
        self.weightSubject = weightSubject
        self.imageSubject = imageSubject
        super.init()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Protocol comformance only
        // Not needed for this demo
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            let age = Int(message["age"] as! String)!
            let height = Int(message["height"] as! String)!
            let weight = Int(message["weight"] as! String)!

            self.ageSubject.send(age)
            self.heightSubject.send(height)
            self.weightSubject.send(weight)
//            if let count = message["message"] as? Int {
//                self.countSubject.send(count)
//            } else {
//                print("There was an error")
//            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            let image = UIImage(data: messageData)!
            self.imageSubject.send(image)
        }
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

final class Model: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
        
    let ageSubject = PassthroughSubject<Int, Never>()
    let heightSubject = PassthroughSubject<Int, Never>()
    let weightSubject = PassthroughSubject<Int, Never>()
    let imageSubject = PassthroughSubject<UIImage, Never>()
    
    @Published private(set) var age: Int = 0
    @Published private(set) var height: Int = 0
    @Published private(set) var weight: Int = 0
    @Published private(set) var image: UIImage = UIImage()
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(
            ageSubject: ageSubject,
            heightSubject: heightSubject,
            weightSubject: weightSubject,
            imageSubject: imageSubject
        )
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        ageSubject
            .assign(to: &$age)
        heightSubject
            .assign(to: &$height)
        weightSubject
            .assign(to: &$weight)
        imageSubject
            .assign(to: &$image)
    }
}
