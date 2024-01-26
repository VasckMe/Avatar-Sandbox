//
//  CharacterViewController.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class CharacterViewController: UIViewController, ViewOwner {
    typealias RootView = CharacterView
    

    // MARK: - Life cycle
    
    override func loadView() {
        view = CharacterView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
