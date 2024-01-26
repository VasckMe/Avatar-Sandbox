//
//  CharacterView.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

final class CharacterView: UIView {

    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
