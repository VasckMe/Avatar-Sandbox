//
//  ASValidationService.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 27.01.24.
//

final class ASValidationService: ASValidationServiceProtocol {
    init() {}
    
    func isValid(text: String?) -> Bool {
        guard
            let text = text,
            let _ = Float(text)
        else {
            return false
        }
        
        return true
    }
}
