import Cocoa
import Foundation

class ButtonImage {
    
    private let size = CGSize(width: 16, height: 16)
    private let defaults = UserDefaults.standard
    
    func createImage(text: String) -> NSImage {
        guard let color = ColorOption(rawValue: defaults.integer(forKey: "ColorOption")),
              let style = IconOption(rawValue: defaults.integer(forKey: "IconOption"))
        else { return whiteOnBlackOneIcon(text: text) }
        switch style {
        case IconOption.oneIcon:
            if color == ColorOption.blackOnWhite {
                return blackOnWhiteOneIcon(text: text)
            } else {
                return whiteOnBlackOneIcon(text: text)
            }
        case IconOption.iconPerMonitor:
            if color == ColorOption.blackOnWhite {
                return blackOnWhitePerMonitor(text: text)
            } else {
                return whiteOnBlackPerMonitor(text: text)
            }
        case IconOption.iconPerSpace:
            if color == ColorOption.blackOnWhite {
                return blackOnWhitePerSpace(text: text)
            } else {
                return whiteOnBlackPerSpace(text: text)
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
    
    private func blackOnWhiteOneIcon(text: String) -> NSImage {
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
    
    private func whiteOnBlackOneIcon(text: String) -> NSImage {
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
    
    private func whiteOnBlackPerMonitor(text: String) -> NSImage {
        return NSImage()
    }
    
    private func blackOnWhitePerMonitor(text:String) -> NSImage {
        return NSImage()
    }
    
    private func whiteOnBlackPerSpace(text: String) -> NSImage {
        return NSImage()
    }
    
    private func blackOnWhitePerSpace(text: String) -> NSImage {
        return NSImage()
    }
    
}

extension NSString {
    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [String : Any]? = nil) {
        let size = self.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
        self.draw(in: centeredRect, withAttributes: attributes)
    }
}
