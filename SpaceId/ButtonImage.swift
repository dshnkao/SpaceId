import Cocoa
import Foundation

class ButtonImage {
    
    private let size = CGSize(width: 16, height: 16)

    private func textAttributes(color: NSColor) -> [String: Any] {
        let font = NSFont.boldSystemFont(ofSize: 11)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        return [ NSFontAttributeName: font,
                 NSForegroundColorAttributeName: color,
                 NSParagraphStyleAttributeName: paragraphStyle
               ] as [String : Any]
    }
    
    func borderedSquare(text: String) -> NSImage {
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
    
    func filledSquare(text: String) -> NSImage {
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
    
}

extension NSString {
    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [String : Any]? = nil) {
        let size = self.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
        self.draw(in: centeredRect, withAttributes: attributes)
    }
}
