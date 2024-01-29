//
//  AvatarModel.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 27.01.24.
//

import UIKit

struct AvatarModel {
    let stats: AvatarStats
    let image: String
}

struct AvatarStats {
    let age: Int
    let height: Float
    let weight: Float
    
    var heightText: String {
        return String(height.rounded())
    }
    
    var weightText: String {
        return String(weight.rounded())
    }
}

