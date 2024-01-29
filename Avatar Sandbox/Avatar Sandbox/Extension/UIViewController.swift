//
//  UIViewController.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

// MARK: - keyboard

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboardWhenTappedAround)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardWhenTappedAround() {
        view.endEditing(true)
    }
}

// MARK: - presentOnMainQueue

extension UIViewController {
    func presentOnMainQueue(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.present(
                viewController,
                animated: animated,
                completion: completion
            )
        }
    }
}

// MARK: - showAlert
extension UIViewController {
    func showAlert(
        title: String? = nil,
        message: String? = nil,
        completion: (() -> Void)? = nil
    ) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel) { _ in
            completion?()
        }
        controller.addAction(action)
        self.presentOnMainQueue(controller, animated: true)
    }
}
