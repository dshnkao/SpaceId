import Foundation

struct Space {
    let id64: Int
    let uuid: String
    let type: Int
    let managedSpaceId: Int
    let number: Int?            // fullscreen apps don't have a number
    let order: Int              // spaces are in order including fullscreen apps
}
