//
//  MenuViewController.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class MenuViewController: UIViewController, ViewOwner {
    typealias RootView = MenuView

    // MARK: - Life cycle
    
    override func loadView() {
        view = MenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }

    // MARK: - Methods
    
}

