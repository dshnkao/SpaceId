import Cocoa
import Foundation

class ButtonImage {
    
    private let size = CGSize(width: 16, height: 16)
    private let defaults = UserDefaults.standard
    
    func createImage(spaceInfo: SpaceInfo) -> NSImage {
        guard let color = Preference.Color(rawValue: defaults.integer(forKey: Preference.color)),
              let style = Preference.Icon(rawValue: defaults.integer(forKey: Preference.icon))
        else { return whiteOnBlackOneIcon(text: getTextForSpace(space: spaceInfo.keyboardFocusSpace)) }
        switch style {
        case Preference.Icon.one:
            if color == Preference.Color.blackOnWhite {
                return blackOnWhiteOneIcon(text: getTextForSpace(space: spaceInfo.keyboardFocusSpace))
            } else {
                return whiteOnBlackOneIcon(text: getTextForSpace(space: spaceInfo.keyboardFocusSpace))
            }
        case Preference.Icon.perMonitor:
            if color == Preference.Color.blackOnWhite {
                return blackOnWhitePerMonitor(spaceInfo: spaceInfo)
            } else {
                return whiteOnBlackPerMonitor(spaceInfo: spaceInfo)
            }
        case Preference.Icon.perSpace:
            if color == Preference.Color.blackOnWhite {
                return blackOnWhitePerSpace(spaceInfo: spaceInfo)
            } else {
                return whiteOnBlackPerSpace(spaceInfo: spaceInfo)
            }
        }
    }

    private func textAttributes(color: NSColor) -> [String: Any] {
        let font = NSFont.boldSystemFont(ofSize: 11)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        return [ NSFontAttributeName: font,
                 NSForegroundColorAttributeName: color,
                 NSParagraphStyleAttributeName: paragraphStyle
               ] as [String : Any]
    }
    
    private func blackOnWhiteOneIcon(text: String, alpha: CGFloat = 1) -> NSImage {
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let image = NSImage(size: size)
        let color = NSColor.init(white: 0, alpha: alpha)
        let path = NSBezierPath(roundedRect: rect, xRadius: 1, yRadius: 1)
        image.lockFocus()
        color.set()
        path.lineWidth = 2
        path.stroke()
        text.drawVerticallyCentered(in: rect, withAttributes: textAttributes(color: color))
        image.unlockFocus()
        image.isTemplate = true
        return image
    }
    
    private func whiteOnBlackOneIcon(text: String, alpha: CGFloat = 1) -> NSImage {
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let image = NSImage(size: size)
        let image1 = NSImage(size: size)
        let image2 = NSImage(size: size)
        let color = NSColor.init(white: 1, alpha: alpha)
        
        image1.lockFocus()
        color.set()
        let path = NSBezierPath(roundedRect: rect, xRadius: 3, yRadius: 3)
        path.fill()
        image1.unlockFocus()
        
        image2.lockFocus()
        text.drawVerticallyCentered(in: rect, withAttributes: textAttributes(color: NSColor.black))
        image2.unlockFocus()

        image.lockFocus()
        image1.draw(in: rect, from: NSZeroRect, operation: NSCompositingOperation.sourceOut, fraction: 1.0)
        image2.draw(in: rect, from: NSZeroRect, operation: NSCompositingOperation.destinationOut, fraction: 1.0)
        image.unlockFocus()
        
        image.isTemplate = true
        return image
    }
    
    private func combine(icons: [NSImage], count: Int) -> NSImage {
        let width = size.width * CGFloat(count) + CGFloat(2 * (count - 1))
        let image = NSImage(size: CGSize(width: width, height: size.height))
        image.lockFocus()
        var x: CGFloat = 0
        for i in icons {
            i.draw(at: NSPoint(x: x, y: 0), from: NSZeroRect, operation: NSCompositingOperation.color, fraction: 1.0)
            x += size.width + 2
        }
        image.unlockFocus()
        image.isTemplate = true
        return image
    }
    
    private func whiteOnBlackPerMonitor(spaceInfo: SpaceInfo) -> NSImage {
        let spaces = spaceInfo.activeSpaces.sorted{ $0.order < $1.order }
        let icons = spaces.map { whiteOnBlackOneIcon(text: getTextForSpace(space: $0)) }
        return combine(icons: icons, count: spaces.count)
    }
    
    private func blackOnWhitePerMonitor(spaceInfo:SpaceInfo) -> NSImage {
        let spaces = spaceInfo.activeSpaces.sorted{ $0.order < $1.order }
        let icons = spaces.map { blackOnWhiteOneIcon(text: getTextForSpace(space: $0)) }
        return combine(icons: icons, count: spaces.count)
    }
    
    private func whiteOnBlackPerSpace(spaceInfo: SpaceInfo) -> NSImage {
        let icons = spaceInfo.allSpaces.map {
            whiteOnBlackOneIcon(text: getTextForSpace(space: $0), alpha: getAlpha(space: $0))
        }
        return combine(icons: icons, count: spaceInfo.allSpaces.count)
    }
    
    private func blackOnWhitePerSpace(spaceInfo: SpaceInfo) -> NSImage {
        let icons = spaceInfo.allSpaces.map {
            blackOnWhiteOneIcon(text: getTextForSpace(space: $0), alpha: getAlpha(space: $0))
        }
        return combine(icons: icons, count: spaceInfo.allSpaces.count)
    }
    
    private func getAlpha(space: Space) -> CGFloat {
        return space.isActive ? 1 : 0.3
    }
    
    private func getTextForSpace(space: Space?) -> String {
        return space.map { $0.number.map { String($0) } ?? "F" } ?? "0"
    }
    
}

extension NSString {
    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [String : Any]? = nil) {
        let size = self.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
        self.draw(in: centeredRect, withAttributes: attributes)
    }
}
