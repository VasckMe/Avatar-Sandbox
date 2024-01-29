//
//  AvatarWatchModel.swift
//  Avatar-Sanbox Watch App
//
//  Created by Anton Kasaryn on 29.01.24.
//

struct AvatarWatchModel {
    var age: Int
    var height: Float
    var weight: Float
    
    var heightText: String {
        return String(height.rounded())
    }
    
    var weightText: String {
        return String(weight.rounded())
    }
}
