//
//  SettingViewType.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

enum SettingViewType {
    case age
    case height
    case weight
    
    var typeTitle: String {
        switch self {
        case .age:
            return "Age"
        case .height:
            return "Height"
        case .weight:
            return "Weight"
        }
    }
}
