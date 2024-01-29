//
//  UITextField.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

// MARK: - errorAnimation

extension UITextField {
    func errorAnimation() {
        let shake = CABasicAnimation(keyPath: "position")
        layer.borderColor = UIColor.red.cgColor
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        shake.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        shake.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        layer.add(shake, forKey: "position")
    }
}
