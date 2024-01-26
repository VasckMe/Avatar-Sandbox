//
//  ASTextFieldDelegate.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

protocol ASTextFieldDelegate: AnyObject {
    func didTriggerTextField(of type: ASTextFieldType, with text: String?)
}
