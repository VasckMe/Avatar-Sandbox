//
//  Avatars.swift
//  Avatar Sandbox
//
//  Created by Anton Kasaryn on 26.01.24.
//

import UIKit

enum Avatars: String, CaseIterable {
    case avatar2
    case avatar3
    case avatar5
    case avatar6
    case avatar7
    case avatar8
    case avatar9
    case avatar10
    case avatar11
    case avatar12
    case avatar13
    case avatar15
    case avatar16
    case avatar17
    case avatar18
    case avatar19
    case avatar20
    
    var value: UIImage? {
        return UIImage(named: self.rawValue)
    }
    
}
