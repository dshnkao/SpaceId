import Cocoa
import Foundation

class SpaceIdentifier {
    
    let conn = _CGSDefaultConnection()
    let defaults = UserDefaults.standard
    
    typealias ScreenNumber = String
    typealias ScreenUUID = String
    
    func getSpaceInfo() -> SpaceInfo {
        
        guard let monitors = CGSCopyManagedDisplaySpaces(conn) as? [[String : Any]],
              let mainDisplay = NSScreen.main(),
              let screenNumber = mainDisplay.deviceDescription["NSScreenNumber"] as? UInt32
        else { return SpaceInfo(keyboardFocusSpace: nil, activeSpaces: [], totalSpaceCount: 0) }
        
        //print(monitors)
        let cfuuid = CGDisplayCreateUUIDFromDisplayID(screenNumber).takeRetainedValue()
        let screenUUID = CFUUIDCreateString(kCFAllocatorDefault, cfuuid) as String
        print(screenUUID)
        let (activeSpaces, spaceCount) = parseSpaces(monitors: monitors)

        print(parseSpaces(monitors: monitors))
        return SpaceInfo(keyboardFocusSpace: activeSpaces[screenUUID], activeSpaces: activeSpaces.map{ $0.value }, totalSpaceCount: spaceCount)
    }
    
    /* returns a mapping of screen uuids and their active space */
    private func parseSpaces(monitors: [[String : Any]]) -> ([ScreenUUID : Space], Int) {
        var ret: [ScreenUUID : Space] = [:]
        var spaceCount = 0
        var counter = 1
        var order = 0
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
            
            let filterFullscreen = spaces.filter{ $0["TileLayoutManager"] as? [String : Any] == nil}
            let target = filterFullscreen.enumerated().first(where: { $1["uuid"] as? String == uuid})
            let number = target == nil ? nil : target!.offset + counter
            
            ret[displayIdentifier] = Space(id64: id64, uuid: uuid, type: type, managedSpaceId: managedSpaceId, number: number, order: order)
            spaceCount += spaces.count
            counter += filterFullscreen.count
            order += 1
        }
        return (ret, spaceCount)
    }
}

