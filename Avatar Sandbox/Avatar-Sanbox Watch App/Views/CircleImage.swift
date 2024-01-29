//
//  CircleImage.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 29.01.24.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(Color.white, lineWidth: 3)
            }
            .shadow(radius: 7)
    }
}
