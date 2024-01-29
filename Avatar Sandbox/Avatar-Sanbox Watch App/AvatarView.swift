//
//  AvatarView.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 27.01.24.
//

import SwiftUI
import WatchConnectivity

struct AvatarStatsSwiftUI {
    var age: Int
    var height: Float
    var weight: Float
    
    var heightText: String {
        return String(height.rounded())
    }
    
    var weightText: String {
        return String(weight.rounded())
    }
}

struct AvatarView: View {
    @StateObject var viewModel = AvatarViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                CircleImage(image: Image(uiImage: viewModel.image))
                    .padding()
                
                NavigationLink {
                    DetailsView(value: $viewModel.avatarStats.age, text: "Age:")
                } label: {
                    Text("Age: \(viewModel.avatarStats.age)")
                        .animation(.easeInOut)
                }
                
                NavigationLink {
                    DetailsView(value: $viewModel.avatarStats.height, text: "Height:")
                } label: {
                    Text("Height: \(viewModel.avatarStats.heightText)")
                        .animation(.easeInOut)
                }
                
                NavigationLink {
                    DetailsView(value: $viewModel.avatarStats.weight, text: "Weight:")
                } label: {
                    Text("Weight: \(viewModel.avatarStats.weightText)")
                        .animation(.easeInOut)
                }
                
                Button("Sync") {
                    viewModel.sync()
                }
                .foregroundColor(Color.blue)
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView()
    }
}
