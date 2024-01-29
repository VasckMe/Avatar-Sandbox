//
//  AvatarWatchView.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 27.01.24.
//

import SwiftUI
import WatchConnectivity

struct AvatarWatchView: View {
    @StateObject var viewModel = AvatarWatchViewModel()
    
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
        AvatarWatchView()
    }
}
