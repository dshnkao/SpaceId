//
//  Preference.swift
//  SpaceId
//
//  Created by Dennis Kao on 9/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Foundation

class Preference {
    
    static let icon = "iconPref"
    enum Icon: Int {
        case one
        case perMonitor
        case perSpace
    }
    
    static let color = "colorPref"
    enum Color: Int {
        case whiteOnBlack
        case blackOnWhite
    }
    
    enum App: String {
        case updateOnLeftClick
        case updateOnAppSwitch
        case launchOnLogin
    }
}
