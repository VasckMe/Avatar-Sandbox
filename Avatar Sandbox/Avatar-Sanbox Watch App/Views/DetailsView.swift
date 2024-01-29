//
//  DetailsView.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 28.01.24.
//

import SwiftUI

struct DetailsView<T: Numeric & CustomStringConvertible>: View {
    @Binding var value: T
    
    let text: String
    
    var body: some View {
        Text(text)
        Text(value.description)
        HStack {
            Button("-") {
                value -= 1
            }
            .disabled(value == 0)
            
            Button("+") {
                value += 1
            }
        }
        .navigationTitle("Avatar")
    }
}
