//
//  Array.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 27.01.24.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        guard self.indices.contains(index) else {
            return nil
        }
        
        return self[index]
    }
}
