//
//  ASInputViewDelegate.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

protocol ASInputViewDelegate: AnyObject {
    func didTriggerTextField(of type: ASInputViewType, with text: String?)
}
