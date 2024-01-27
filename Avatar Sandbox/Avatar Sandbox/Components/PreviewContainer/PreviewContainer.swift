//
//  PreviewContainer.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 27.01.24.
//

import SwiftUI

struct PreviewContainer<T: UIView>: UIViewRepresentable {
    let view: T
    
    init(_ viewBuilder: @escaping () -> T) {
        view = viewBuilder()
    }
    
    func makeUIView(context: Context) -> T {
        return view
    }
    
    func updateUIView(_ view: T, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
