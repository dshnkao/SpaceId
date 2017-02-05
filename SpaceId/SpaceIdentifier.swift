//
//  SpaceIdentifierCGS.swift
//  SpaceId
//
//  Created by Dennis Kao on 5/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Cocoa
import Foundation

class SpaceIdentifier {
    
    let conn = _CGSDefaultConnection()
    
    typealias ScreenNumber = String
    typealias ScreenUUID = String
    
    func getActiveSpaceNumber() -> Int {
        
        guard let monitors = CGSCopyManagedDisplaySpaces(conn) as? [[String : Any]],
              let mainDisplay = NSScreen.main(),
              let screenNumber = mainDisplay.deviceDescription["NSScreenNumber"] as? UInt32
        else { return 0 }
        

        let cfuuid = CGDisplayCreateUUIDFromDisplayID(screenNumber).takeRetainedValue()
        let screenUUID = CFUUIDCreateString(kCFAllocatorDefault, cfuuid) as String
        print(screenUUID)
        let activeSpaces = parseSpaces(monitors: monitors)

        print(parseSpaces(monitors: monitors))
        return activeSpaces[screenUUID]?.number ?? 0
    }
    
    /* returns a mapping of screen uuids and their active space */
    private func parseSpaces(monitors: [[String : Any]]) -> [ScreenUUID : Space] {
        var ret: [ScreenUUID : Space] = [:]
        var counter = 1
        for m in monitors {
            guard let current = m["Current Space"] as? [String : Any],
                  let spaces = m["Spaces"] as? [[String : Any]],
                  let displayIdentifier = m["Display Identifier"] as? String
            else { continue }
            guard let id64 = current["id64"] as? Int,
                  let uuid = current["uuid"] as? String,
                  let type = current["type"] as? Int,
                  let managedSpaceId = current["ManagedSpaceID"] as? Int
            else { continue }
            guard let target = spaces.enumerated().first(where: { $1["uuid"] as? String == uuid}) else { continue }
            ret[displayIdentifier] = Space(id64: id64, uuid: uuid, type: type, managedSpaceId: managedSpaceId, number: target.offset+counter)
            counter += spaces.count
        }
        return ret
    }
}

