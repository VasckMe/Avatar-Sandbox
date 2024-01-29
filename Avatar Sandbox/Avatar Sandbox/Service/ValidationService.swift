//
//  ValidationService.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 27.01.24.
//

protocol ValidationServiceProtocol {
    func isValidAge(text: String) -> Bool
    func isValidHeight(text: String) -> Bool
    func isValidWeight(text: String) -> Bool
}

final class ValidationService {
    static let ageValidRange = 1...100
    static let heightValidRange = Float(20.0)...Float(100.0)
    static let weightValidRange = Float(1.0)...Float(100.0)
}

// MARK: - ValidationServiceProtocol

extension ValidationService: ValidationServiceProtocol {
    func isValidAge(text: String) -> Bool {
        guard
            let age = Int(text),
            ValidationService.ageValidRange.contains(age)
        else {
            return false
        }

        return true
    }
    
    func isValidHeight(text: String) -> Bool {
        guard
            let height = Float(text),
            ValidationService.heightValidRange.contains(height)
        else {
            return false
        }
        
        return true
    }
    
    func isValidWeight(text: String) -> Bool {
        guard
            let weight = Float(text),
            ValidationService.weightValidRange.contains(weight)
        else {
            return false
        }
        
        return true
    }
}
