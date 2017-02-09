import Cocoa
import Foundation

class ButtonImage {
    
    private let size = CGSize(width: 16, height: 16)
    private let defaults = UserDefaults.standard
    
    func createImage(spaceInfo: SpaceInfo) -> NSImage {
        guard let color = Preference.Color(rawValue: defaults.integer(forKey: Preference.color)),
              let style = Preference.Icon(rawValue: defaults.integer(forKey: Preference.icon))
        else { return whiteOnBlackOneIcon(space: spaceInfo.keyboardFocusSpace) }
        switch style {
        case Preference.Icon.one:
            if color == Preference.Color.blackOnWhite {
                return blackOnWhiteOneIcon(space: spaceInfo.keyboardFocusSpace)
            } else {
                return whiteOnBlackOneIcon(space: spaceInfo.keyboardFocusSpace)
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
    
    private func blackOnWhiteOneIcon(space: Space?) -> NSImage {
        let text = getTextForSpace(space: space)
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let image = NSImage(size: size)
        image.lockFocus()
        let path = NSBezierPath(roundedRect: rect, xRadius: 3, yRadius: 3)
        path.lineWidth = 2
        path.stroke()
        text.drawVerticallyCentered(in: rect, withAttributes: textAttributes(color: NSColor.black))
        image.unlockFocus()
        image.isTemplate = true
        return image
    }
    
    private func whiteOnBlackOneIcon(space: Space?) -> NSImage {
        let text = getTextForSpace(space: space)
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let image = NSImage(size: size)
        let image1 = NSImage(size: size)
        let image2 = NSImage(size: size)
        
        image1.lockFocus()
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
    
    private func whiteOnBlackPerMonitor(spaceInfo: SpaceInfo) -> NSImage {
        return NSImage()
    }
    
    private func blackOnWhitePerMonitor(spaceInfo:SpaceInfo) -> NSImage {
        return NSImage()
    }
    
    private func whiteOnBlackPerSpace(spaceInfo: SpaceInfo) -> NSImage {
        return NSImage()
    }
    
    private func blackOnWhitePerSpace(spaceInfo: SpaceInfo) -> NSImage {
        return NSImage()
    }
    
    private func getTextForSpace(space: Space?) -> String {
        if let s = space {
            if let num = s.number  {
                return String(num)
            }
            else {
                return "F"
            }
        }
        else {
            return "0"
        }
    }
    
}

extension NSString {
    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [String : Any]? = nil) {
        let size = self.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
        self.draw(in: centeredRect, withAttributes: attributes)
    }
}
