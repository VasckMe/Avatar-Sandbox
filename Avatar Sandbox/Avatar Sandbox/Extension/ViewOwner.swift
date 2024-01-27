//
//  ViewOwner.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

// MARK: - ViewOwner

protocol ViewOwner: AnyObject {
    associatedtype RootView: UIView
}

extension ViewOwner where Self: UIViewController {
    var rootView: RootView {
        guard let rootView = view as? RootView else {
            fatalError("Not found \(RootView.description()) as rootView. Not \(type(of: view))")
        }
        return rootView
    }
}
